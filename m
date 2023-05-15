Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A7317730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47DC433EF;
	Mon, 15 May 2023 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684174005;
	bh=chvltjbg9STnTSqBYHwXHXLrdnemu/i9uHfz9XCKMwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=heETkaU0M4HsBfJ54zZz0COqjTYhjNSDgYqQxeltlgugeVTlcSgqf0aENK9wcbPC5
	 CBy7Jv3C9LEez67NIdci6XCksRA1Swf5PUIxuiB/WR9UMmJ3lO9bbFmR8jbxI+0Jcz
	 UZ7TCXsTjdEfdu2extBS2AW+urBGqzyWvHguJHy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Rob Clark <robdclark@gmail.com>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.4 277/282] drm/msm: Fix double pm_runtime_disable() call
Date: Mon, 15 May 2023 18:30:55 +0200
Message-Id: <20230515161730.678246942@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Luz <luzmaximilian@gmail.com>

commit ce0db505bc0c51ef5e9ba446c660de7e26f78f29 upstream.

Following commit 17e822f7591f ("drm/msm: fix unbalanced
pm_runtime_enable in adreno_gpu_{init, cleanup}"), any call to
adreno_unbind() will disable runtime PM twice, as indicated by the call
trees below:

  adreno_unbind()
   -> pm_runtime_force_suspend()
   -> pm_runtime_disable()

  adreno_unbind()
   -> gpu->funcs->destroy() [= aNxx_destroy()]
   -> adreno_gpu_cleanup()
   -> pm_runtime_disable()

Note that pm_runtime_force_suspend() is called right before
gpu->funcs->destroy() and both functions are called unconditionally.

With recent addition of the eDP AUX bus code, this problem manifests
itself when the eDP panel cannot be found yet and probing is deferred.
On the first probe attempt, we disable runtime PM twice as described
above. This then causes any later probe attempt to fail with

  [drm:adreno_load_gpu [msm]] *ERROR* Couldn't power up the GPU: -13

preventing the driver from loading.

As there seem to be scenarios where the aNxx_destroy() functions are not
called from adreno_unbind(), simply removing pm_runtime_disable() from
inside adreno_unbind() does not seem to be the proper fix. This is what
commit 17e822f7591f ("drm/msm: fix unbalanced pm_runtime_enable in
adreno_gpu_{init, cleanup}") intended to fix. Therefore, instead check
whether runtime PM is still enabled, and only disable it in that case.

Fixes: 17e822f7591f ("drm/msm: fix unbalanced pm_runtime_enable in adreno_gpu_{init, cleanup}")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Link: https://lore.kernel.org/r/20220606211305.189585-1-luzmaximilian@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -913,7 +913,8 @@ void adreno_gpu_cleanup(struct adreno_gp
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
-	pm_runtime_disable(&priv->gpu_pdev->dev);
+	if (pm_runtime_enabled(&priv->gpu_pdev->dev))
+		pm_runtime_disable(&priv->gpu_pdev->dev);
 
 	icc_put(gpu->icc_path);
 


