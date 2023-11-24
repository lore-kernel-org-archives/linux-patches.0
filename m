Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5543E39FE9;
	Fri, 24 Nov 2023 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNjueUv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24A9C433C8;
	Fri, 24 Nov 2023 18:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850299;
	bh=SKL6kn/8unJKR37CoBA+goWHo7aRf9VhtKryCZElJe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNjueUv+RtamrR4ArWdU/whonASMmMdGJkJv62bQhMxk8WyXJY5UJ0dfefZ85WzU6
	 z1WXLKXe4IuBFi7tF+t51V5giyQ6+3YnPT/T6IOboZDRNQ+zP1Kzff9EmLWchZ42KH
	 pbM0aggt/VmRYVstI0lGUhn8O1QWdkvKz2h6VJdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hansen Dsouza <hansen.dsouza@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 525/530] drm/amd/display: Guard against invalid RPTR/WPTR being set
Date: Fri, 24 Nov 2023 17:51:31 +0000
Message-ID: <20231124172044.169998887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 1ffa8602e39b89469dc703ebab7a7e44c33da0f7 upstream.

[WHY]
HW can return invalid values on register read, guard against these being
set and causing us to access memory out of range and page fault.

[HOW]
Guard at sync_inbox1 and guard at pushing commands.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -658,9 +658,16 @@ enum dmub_status dmub_srv_sync_inbox1(st
 		return DMUB_STATUS_INVALID;
 
 	if (dmub->hw_funcs.get_inbox1_rptr && dmub->hw_funcs.get_inbox1_wptr) {
-		dmub->inbox1_rb.rptr = dmub->hw_funcs.get_inbox1_rptr(dmub);
-		dmub->inbox1_rb.wrpt = dmub->hw_funcs.get_inbox1_wptr(dmub);
-		dmub->inbox1_last_wptr = dmub->inbox1_rb.wrpt;
+		uint32_t rptr = dmub->hw_funcs.get_inbox1_rptr(dmub);
+		uint32_t wptr = dmub->hw_funcs.get_inbox1_wptr(dmub);
+
+		if (rptr > dmub->inbox1_rb.capacity || wptr > dmub->inbox1_rb.capacity) {
+			return DMUB_STATUS_HW_FAILURE;
+		} else {
+			dmub->inbox1_rb.rptr = rptr;
+			dmub->inbox1_rb.wrpt = wptr;
+			dmub->inbox1_last_wptr = dmub->inbox1_rb.wrpt;
+		}
 	}
 
 	return DMUB_STATUS_OK;
@@ -694,6 +701,11 @@ enum dmub_status dmub_srv_cmd_queue(stru
 	if (!dmub->hw_init)
 		return DMUB_STATUS_INVALID;
 
+	if (dmub->inbox1_rb.rptr > dmub->inbox1_rb.capacity ||
+	    dmub->inbox1_rb.wrpt > dmub->inbox1_rb.capacity) {
+		return DMUB_STATUS_HW_FAILURE;
+	}
+
 	if (dmub_rb_push_front(&dmub->inbox1_rb, cmd))
 		return DMUB_STATUS_OK;
 


