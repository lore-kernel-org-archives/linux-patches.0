Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E895535FC3;
	Wed, 23 Sep 2026 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174743; cv=none; b=ukJUCHJ0axU8vZtue+PGlMppKEjehMNdoSa0/DhneSt5WUHtV2WniIUJVkykYV83DMUDOBydWtJl+RrhEIZZKpXiEDq+UuD5q64vjNS8yZXx4NV0D2G7O3cWgcUqyAIZC+xVmc5IlH46JJAiXg70ilw4uOO3I0NJNZ8GwUHL2xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174743; c=relaxed/simple;
	bh=nvHz7xAzYcwRjsyrAISYqbTfKDccZrqrWUDqvjP2Vtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/AxN0fuSVXB0sDt2bU5TUzGkRZ++0/J6GIkP+svbc97yEB9FW9A9IiXnanGD3RFliYN91NEbY55iD7V2xfMKujLNL5Dxf9RdLzANO6FHxnsk9/Yg3MH3j2OdgGW3l8Qgr0b3dYcNbGoZ3DNY6Kqj+jLsf0xoaNNj0PFFp0UHns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFuUuhW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFuUuhW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3E81F000FF;
	Wed, 23 Sep 2026 14:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174741;
	bh=+POri+sXx6uhPGA2gQr3GHrs4ZxQvqpTM1lVZ64quOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFuUuhW55O0qC5eUvKIGBlV4SdRigH53aJjmV8oghmcdms5nTuK9qnII3rq/v/pzd
	 UnM6NaLRmC6S5A1sA1PskQV1VCI8aPJaSyiyLKn4zkqiOrD0fFM314cRGXjUq9xT7I
	 OvGS2yD5twgqUxP7wEt8QIXiCOdB32/8zNYQN2s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.18 212/398] drm/nouveau/gsp: Increase delay for magic sleep in r535_gsp_fini()
Date: Wed, 23 Sep 2026 16:04:46 +0200
Message-ID: <20260923140648.919476103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lyude Paul <lyude@redhat.com>

commit bbb9293c9bb792f3f16c842f223b8c97bdbaf227 upstream.

As it turns out, Turing isn't the only architecture that needs this. On
this Dell Precision 7780 with an AD103 GPU, along with pretty much every
other laptop I tested, runtime PM is still somewhat unreliable. At first
glance it seems as if it's fixed, but lowering the autosuspend delay to
500ms and then doing a stress test of suspend/resume cycles on the GPU ends
up causing everything to start timing out.

After quite a lot of digging, I eventually landed back on this magic
timeout in r535_gsp_fini(). As it turns out, increasing the timeout ends up
fixing the runtime PM issues as far as I can tell, even during intense
stress testing.

Unfortunately after spending quite a bit of time trying to dig through
OpenRM to figure out what this magic sleep is actually doing, I've also
come up short with any reasonable explanation. In lieu of that, I'm going
to include the observations I did make while trying to figure this out in
hopes someone eventually does figure this out:

* The magic sleep has to occur after fbsr is initialized. Performing it at
  any time before that doesn't appear to work.
* In situations where runtime PM starts getting flaky, some rather
  interesting visual effects end up happening on occasion before the GPU
  fully falls over. In particular, squares that look like the result of an
  incomplete blitting operation to a tiled buffer end up showing up on
  applications like vkcube. Interestingly enough, they remain in precisely
  the same place between runtime PM cycles until the GPU falls over - even
  when restarting vkcube multiple times, and even when vkcube is actively
  updating the screen. Even more interestingly, they're not limited to a
  specific framebuffer - you can see the squares changing as the cube
  rotates around.
  We cannot however, say that this is likely to be a incomplete fbsr
  operation. The magic sleep happens before fbsr is actually saved (which
  happens on the GSP unload), so it's something else.
* During a short bit of testing with a desktop that I have, the magic sleep
  seemed to make no difference to whether or not suspend/resume works. It
  seems to generally work almost always. So we can assume this is likely
  exclusive to runtime PM, not S3.

As well, here's a list of the things I tried before settling on the magic
sleep:

* Hooking up NV2080_CTRL_CMD_INTERNAL_GCX_ENTRY_PREREQUISITE and then
  blocking runtime PM until OpenRM signals that GC6/GCOFF is ready appears
  to make no difference.
* Hooking up some (maybe not all, unsure about that part) bits of comptag
  saving including:
  * Fetching static memsys information from GSP
  * Adding the size of the comptag storage to the fbsr data
  * Adding a GA103+ workaround for disabling raw compression mode during
    fbsr (it doesn't seem like it applies for any systems I tried it on
    anyhow)
  * Setting bPreserveVideoMemoryAllocations=1 in GspSystemInfo

So, until we can figure this out properly - just sleep for longer.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 53dac0623853 ("drm/nouveau/gsp: add support for 570.144")
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20260814194542.781955-5-lyude@redhat.com
(cherry picked from commit 09b47186a4164f3aaa3591313f80794443117342)
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c
@@ -1760,8 +1760,12 @@ r535_gsp_fini(struct nvkm_gsp *gsp, enum
 		 * TODO: Debug the GSP firmware / RPC handling to find out why
 		 * without this Turing (but none of the other architectures)
 		 * ends up resetting all channels after resume.
+		 * Additionally, runtime suspend on other architectures quickly
+		 * becomes unreliable without this sleep. If you're experiencing
+		 * issues with runtime suspend, try bumping this delay up and
+		 * sending a patch if it fixes your GPU.
 		 */
-		msleep(50);
+		msleep(200);
 	}
 
 	ret = r535_gsp_rpc_unloading_guest_driver(gsp, suspend);


