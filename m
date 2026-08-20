Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444AE360745;
	Thu, 20 Aug 2026 15:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238661; cv=none; b=hWAs1XNxBDxsWEJ6SpecyuXWRvHmeV87Oc1RkD7CN6sy+FYKoTj3LyXYitpkvUYPIPTJSYjcTi3+DGYPxfOCB6kudmwFqU7kT7scPCXjJaqhhtfoPz3DSNUSTIDpiqz8TO4FvZs0kCRaxiN0zY767VNzhbbfwo2HzRSrwsuf6wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238661; c=relaxed/simple;
	bh=w1eiC/GPaSoBNs8XVeHTj5B3XBR2+PCsf/f0B3VYx1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usFbx3NfNJJt9tDBH+P7wdS+06ZQOUiqx6WeZsr1/ZZREs9FN6NZx7/nHiT8ix20HijJKCJf5p00S25wQqMzeVGgDUF0U1LTh3QZ+xLpm6RAZAszcpJb9w2gNYDdY5c4ueZNqdCXiNxbOMWEh9BfDwSTtlounyX1SQnZpmj5m2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rit3hm9S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rit3hm9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9A11F000E9;
	Thu, 20 Aug 2026 15:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238660;
	bh=AqCGBm/Kr59Bp92YtvYecYueCLX6GP19pD5qLXiuI1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rit3hm9STrBze7ld04pSvF7ziLSWkWcEda4nkpnsLm3Mfmww9E9owUqcddK/m0new
	 W5xwqXx2IdFVunIQwdurYlU5J4/utcIvokgU+F+TLQ/TnT4TEWQF7WSsZLRCsd6okp
	 8ySTR+3k185QN+LLH59RvqvdJtqmyn/umZm1ZmBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 223/228] drm/xe: Fix a bug in pc_adjust_freq_bounds()
Date: Thu, 20 Aug 2026 16:56:05 +0200
Message-ID: <20260820145251.850102436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 5cf82c8cec90056511eb881a267aab6101eaf57a ]

In cases where min frequency was actually greater than BMG_MIN_FREQ,
we were not using the updated min frequency as there was a missing
call to pc_action_query_task_state() between the two settings of
min frequency. Since we know what min_freq was last set, use that
cached value while comparing to BMG_MIN_FREQ to fix this issue.

v2: pc->freq_ready is not set until after pc_adjust_freq_bounds(). Stay
with pc_action_query_task_state() instead.

v3: Update commit message (Stuart)

Fixes: bdde16c9ac5c ("drm/xe/bmg: Update Wa_14022085890")
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20260805234649.2076384-1-vinay.belgaumkar@intel.com
(cherry picked from commit a2c2d2b13a9ea9494d2d76b46273833111749507)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index 7ecd91ad6192d..e3d080d23b8bf 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -911,6 +911,7 @@ static bool pc_needs_min_freq_change(struct xe_guc_pc *pc)
 static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 {
 	int ret;
+	u32 min_freq;
 
 	lockdep_assert_held(&pc->freq_lock);
 
@@ -933,8 +934,14 @@ static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 	 * Same thing happens for Server platforms where min is listed as
 	 * RPMax
 	 */
-	if (pc_get_min_freq(pc) > pc->rp0_freq)
+	min_freq = pc_get_min_freq(pc);
+	if (min_freq > pc->rp0_freq) {
 		ret = pc_set_min_freq(pc, pc->rp0_freq);
+		if (ret)
+			goto out;
+
+		min_freq = pc->rp0_freq;
+	}
 
 	/*
 	 * Setting GT RP min frequency to 1.2GHz by default for
@@ -947,8 +954,8 @@ static int pc_adjust_freq_bounds(struct xe_guc_pc *pc)
 	 * we aren't expecting high power output across board
 	 *
 	 */
-	if (pc_needs_min_freq_change(pc))
-		ret = pc_set_min_freq(pc, max(BMG_MIN_FREQ, pc_get_min_freq(pc)));
+	if (pc_needs_min_freq_change(pc) && min_freq < BMG_MIN_FREQ)
+		ret = pc_set_min_freq(pc, BMG_MIN_FREQ);
 
 out:
 	return ret;
-- 
2.53.0



