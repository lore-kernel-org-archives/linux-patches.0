Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07D9C129;
	Mon,  1 Apr 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988617; cv=none; b=iZfVgaAgRU8+llLO4CNgflOBVo/V+OtujZal7Sk5CykEoFDuolRsyLdafY9jD7G8gqfku/s4/rHkMhn+VqHBndEsDQzfNoajpPCPkvwtW/JsyRgxTykRoZ2CPy3ZPyKxgZDgelTSIZcvqVJjA0zSC2uYfEElTblvPVDrxCu+bow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988617; c=relaxed/simple;
	bh=PIYSN0sN+e3Q7EPpVMVdPLVwOixmy9Yig7SVGIiUTd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz63BhEd47AIsquNs7vFq1aMWg+sEXoXM2jmgMwugXaSOjSYIkaLBfl5Jxwkivl/PBI3jOx2vyJH7OmzQKDevHx0zHCfKLliuXgwc4f2qtnH7t/hO08l3251DawJNouDgSnwFEQ4efP0MrIOKVQDTWYYCPSi6w2Y/Bp6ohV33yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZjTav0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZjTav0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A20C433F1;
	Mon,  1 Apr 2024 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988617;
	bh=PIYSN0sN+e3Q7EPpVMVdPLVwOixmy9Yig7SVGIiUTd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZjTav0jWz7lKfq90TVLXLFKW34YWkPsea76ijQudxrlGbi7M6v52nWAFh54NAYnR
	 m09lZ7RGxr0vpXOZl9Ai+x8ggfK/Dcprvln7XcnC6VncyzY/ALM2wgefHfRg8DkFYE
	 +AFSAu6bplU65OrcAtKw6LMCVuQiyYy4b6Q5WIcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.7 239/432] drm/nouveau: fix stale locked mutex in nouveau_gem_ioctl_pushbuf
Date: Mon,  1 Apr 2024 17:43:46 +0200
Message-ID: <20240401152600.265821595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Herbst <kherbst@redhat.com>

commit daf8739c3322a762ce84f240f50e0c39181a41ab upstream.

If VM_BIND is enabled on the client the legacy submission ioctl can't be
used, however if a client tries to do so regardless it will return an
error. In this case the clients mutex remained unlocked leading to a
deadlock inside nouveau_drm_postclose or any other nouveau ioctl call.

Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Cc: Danilo Krummrich <dakr@redhat.com>
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240305133853.2214268-1-kherbst@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -758,7 +758,7 @@ nouveau_gem_ioctl_pushbuf(struct drm_dev
 		return -ENOMEM;
 
 	if (unlikely(nouveau_cli_uvmm(cli)))
-		return -ENOSYS;
+		return nouveau_abi16_put(abi16, -ENOSYS);
 
 	list_for_each_entry(temp, &abi16->channels, head) {
 		if (temp->chan->chid == req->channel) {


