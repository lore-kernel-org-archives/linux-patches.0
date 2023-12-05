Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E040D6FB1;
	Tue,  5 Dec 2023 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eahI7L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF0CC433C7;
	Tue,  5 Dec 2023 03:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747174;
	bh=P1Cr/kp6UsfNSgJM0OriKXil0Qs6Dwc+X5MwIp8C0PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eahI7L1qiCI4T8+B4jIhMNxEgdyw+DnfyaPViShTA3AWO/kXhY6E8ijsTVZlLErM
	 OtIEOAlFzn4+Ji9B8UEDVO9loyxEbfNhGQi2Cq+JkMahHMYrE28S/DqqYlqBkDFdei
	 cCJFIlb0nioH/2iyAUq0t6lhtpMlgk7FZLgICKxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	"JinZe.Xu" <JinZe.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/107] drm/amd/display: Restore rptr/wptr for DMCUB as workaround
Date: Tue,  5 Dec 2023 12:17:01 +0900
Message-ID: <20231205031537.011097570@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JinZe.Xu <JinZe.Xu@amd.com>

[ Upstream commit 8f3589bb6fcea397775398cba4fbcc46829a60ed ]

[Why]
States may be desync after resume.

[How]
Sync sw state with hw state.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: JinZe.Xu <JinZe.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 1ffa8602e39b ("drm/amd/display: Guard against invalid RPTR/WPTR being set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dmub/dmub_srv.h     | 14 ++++++++++++++
 .../gpu/drm/amd/display/dmub/src/dmub_dcn20.c   |  5 +++++
 .../gpu/drm/amd/display/dmub/src/dmub_dcn20.h   |  2 ++
 .../gpu/drm/amd/display/dmub/src/dmub_dcn31.c   |  5 +++++
 .../gpu/drm/amd/display/dmub/src/dmub_dcn31.h   |  2 ++
 .../gpu/drm/amd/display/dmub/src/dmub_dcn32.c   |  5 +++++
 .../gpu/drm/amd/display/dmub/src/dmub_dcn32.h   |  2 ++
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c | 17 +++++++++++++++++
 8 files changed, 52 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dmub/dmub_srv.h b/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
index a21fe7b037d1f..aaabaab49809d 100644
--- a/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
+++ b/drivers/gpu/drm/amd/display/dmub/dmub_srv.h
@@ -332,6 +332,8 @@ struct dmub_srv_hw_funcs {
 	void (*setup_mailbox)(struct dmub_srv *dmub,
 			      const struct dmub_region *inbox1);
 
+	uint32_t (*get_inbox1_wptr)(struct dmub_srv *dmub);
+
 	uint32_t (*get_inbox1_rptr)(struct dmub_srv *dmub);
 
 	void (*set_inbox1_wptr)(struct dmub_srv *dmub, uint32_t wptr_offset);
@@ -590,6 +592,18 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
  */
 enum dmub_status dmub_srv_hw_reset(struct dmub_srv *dmub);
 
+/**
+ * dmub_srv_sync_inbox1() - sync sw state with hw state
+ * @dmub: the dmub service
+ *
+ * Sync sw state with hw state when resume from S0i3
+ *
+ * Return:
+ *   DMUB_STATUS_OK - success
+ *   DMUB_STATUS_INVALID - unspecified error
+ */
+enum dmub_status dmub_srv_sync_inbox1(struct dmub_srv *dmub);
+
 /**
  * dmub_srv_cmd_queue() - queues a command to the DMUB
  * @dmub: the dmub service
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.c
index a6540e27044d2..98dad0d47e72c 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.c
@@ -282,6 +282,11 @@ void dmub_dcn20_setup_mailbox(struct dmub_srv *dmub,
 	REG_WRITE(DMCUB_INBOX1_SIZE, inbox1->top - inbox1->base);
 }
 
+uint32_t dmub_dcn20_get_inbox1_wptr(struct dmub_srv *dmub)
+{
+	return REG_READ(DMCUB_INBOX1_WPTR);
+}
+
 uint32_t dmub_dcn20_get_inbox1_rptr(struct dmub_srv *dmub)
 {
 	return REG_READ(DMCUB_INBOX1_RPTR);
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.h b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.h
index c2e5831ac52cc..1df128e57ed3b 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.h
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn20.h
@@ -202,6 +202,8 @@ void dmub_dcn20_setup_windows(struct dmub_srv *dmub,
 void dmub_dcn20_setup_mailbox(struct dmub_srv *dmub,
 			      const struct dmub_region *inbox1);
 
+uint32_t dmub_dcn20_get_inbox1_wptr(struct dmub_srv *dmub);
+
 uint32_t dmub_dcn20_get_inbox1_rptr(struct dmub_srv *dmub);
 
 void dmub_dcn20_set_inbox1_wptr(struct dmub_srv *dmub, uint32_t wptr_offset);
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c
index 89d24fb7024e2..5e952541e72d5 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.c
@@ -242,6 +242,11 @@ void dmub_dcn31_setup_mailbox(struct dmub_srv *dmub,
 	REG_WRITE(DMCUB_INBOX1_SIZE, inbox1->top - inbox1->base);
 }
 
+uint32_t dmub_dcn31_get_inbox1_wptr(struct dmub_srv *dmub)
+{
+	return REG_READ(DMCUB_INBOX1_WPTR);
+}
+
 uint32_t dmub_dcn31_get_inbox1_rptr(struct dmub_srv *dmub)
 {
 	return REG_READ(DMCUB_INBOX1_RPTR);
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.h b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.h
index eb62410941473..89c5a948b67d5 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.h
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn31.h
@@ -204,6 +204,8 @@ void dmub_dcn31_setup_windows(struct dmub_srv *dmub,
 void dmub_dcn31_setup_mailbox(struct dmub_srv *dmub,
 			      const struct dmub_region *inbox1);
 
+uint32_t dmub_dcn31_get_inbox1_wptr(struct dmub_srv *dmub);
+
 uint32_t dmub_dcn31_get_inbox1_rptr(struct dmub_srv *dmub);
 
 void dmub_dcn31_set_inbox1_wptr(struct dmub_srv *dmub, uint32_t wptr_offset);
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
index 9c20516be066c..d2f03f797279f 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.c
@@ -266,6 +266,11 @@ void dmub_dcn32_setup_mailbox(struct dmub_srv *dmub,
 	REG_WRITE(DMCUB_INBOX1_SIZE, inbox1->top - inbox1->base);
 }
 
+uint32_t dmub_dcn32_get_inbox1_wptr(struct dmub_srv *dmub)
+{
+	return REG_READ(DMCUB_INBOX1_WPTR);
+}
+
 uint32_t dmub_dcn32_get_inbox1_rptr(struct dmub_srv *dmub)
 {
 	return REG_READ(DMCUB_INBOX1_RPTR);
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h
index 7d1a6eb4d6657..f15336b6e22be 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn32.h
@@ -206,6 +206,8 @@ void dmub_dcn32_setup_windows(struct dmub_srv *dmub,
 void dmub_dcn32_setup_mailbox(struct dmub_srv *dmub,
 			      const struct dmub_region *inbox1);
 
+uint32_t dmub_dcn32_get_inbox1_wptr(struct dmub_srv *dmub);
+
 uint32_t dmub_dcn32_get_inbox1_rptr(struct dmub_srv *dmub);
 
 void dmub_dcn32_set_inbox1_wptr(struct dmub_srv *dmub, uint32_t wptr_offset);
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index f58803de37cb0..6b8bd556c872f 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -167,6 +167,7 @@ static bool dmub_srv_hw_setup(struct dmub_srv *dmub, enum dmub_asic asic)
 		funcs->backdoor_load = dmub_dcn20_backdoor_load;
 		funcs->setup_windows = dmub_dcn20_setup_windows;
 		funcs->setup_mailbox = dmub_dcn20_setup_mailbox;
+		funcs->get_inbox1_wptr = dmub_dcn20_get_inbox1_wptr;
 		funcs->get_inbox1_rptr = dmub_dcn20_get_inbox1_rptr;
 		funcs->set_inbox1_wptr = dmub_dcn20_set_inbox1_wptr;
 		funcs->is_supported = dmub_dcn20_is_supported;
@@ -243,6 +244,7 @@ static bool dmub_srv_hw_setup(struct dmub_srv *dmub, enum dmub_asic asic)
 		funcs->backdoor_load = dmub_dcn31_backdoor_load;
 		funcs->setup_windows = dmub_dcn31_setup_windows;
 		funcs->setup_mailbox = dmub_dcn31_setup_mailbox;
+		funcs->get_inbox1_wptr = dmub_dcn31_get_inbox1_wptr;
 		funcs->get_inbox1_rptr = dmub_dcn31_get_inbox1_rptr;
 		funcs->set_inbox1_wptr = dmub_dcn31_set_inbox1_wptr;
 		funcs->setup_out_mailbox = dmub_dcn31_setup_out_mailbox;
@@ -281,6 +283,7 @@ static bool dmub_srv_hw_setup(struct dmub_srv *dmub, enum dmub_asic asic)
 		funcs->backdoor_load_zfb_mode = dmub_dcn32_backdoor_load_zfb_mode;
 		funcs->setup_windows = dmub_dcn32_setup_windows;
 		funcs->setup_mailbox = dmub_dcn32_setup_mailbox;
+		funcs->get_inbox1_wptr = dmub_dcn32_get_inbox1_wptr;
 		funcs->get_inbox1_rptr = dmub_dcn32_get_inbox1_rptr;
 		funcs->set_inbox1_wptr = dmub_dcn32_set_inbox1_wptr;
 		funcs->setup_out_mailbox = dmub_dcn32_setup_out_mailbox;
@@ -666,6 +669,20 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
 	return DMUB_STATUS_OK;
 }
 
+enum dmub_status dmub_srv_sync_inbox1(struct dmub_srv *dmub)
+{
+	if (!dmub->sw_init)
+		return DMUB_STATUS_INVALID;
+
+	if (dmub->hw_funcs.get_inbox1_rptr && dmub->hw_funcs.get_inbox1_wptr) {
+		dmub->inbox1_rb.rptr = dmub->hw_funcs.get_inbox1_rptr(dmub);
+		dmub->inbox1_rb.wrpt = dmub->hw_funcs.get_inbox1_wptr(dmub);
+		dmub->inbox1_last_wptr = dmub->inbox1_rb.wrpt;
+	}
+
+	return DMUB_STATUS_OK;
+}
+
 enum dmub_status dmub_srv_hw_reset(struct dmub_srv *dmub)
 {
 	if (!dmub->sw_init)
-- 
2.42.0



