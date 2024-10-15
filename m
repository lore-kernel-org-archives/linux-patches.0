Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB40819B3FF;
	Tue, 15 Oct 2024 11:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992832; cv=none; b=oELHgFMfvDBbH7uR4DPCoWEHlw57diDWrMDiciDtBgFwSq92lfmQI9VI2feZfKE5U44dtpapr54JygEA/UlMA+JpYimFO/gl6SzIZ8/zhgK3gdb3GnyqzKIeq3am8E336eAn5+39EtdPKF0F0nMgkIIr+v3HhFDGGVfEIUstQyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992832; c=relaxed/simple;
	bh=CneV3B0iEK//hM1XR1rhzHrd+cRckaJPzIzBeXmOhIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHd5U5m4erskibc6X9/hSZXLnczNT+W50RK95XZxzkVbstB38D954Z3hmES4JfYtk1jV+tdIfjTOvGTfIyHDxeX5WwOwhVH38qpF/oik2ImAjv3AVsPtuRU0cdKgsnXixZCOUWbx0k0so5U50JG6AO6G8e5ILoHx5EaKZ60eD3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWs2DvNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWs2DvNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CA9C4CEC6;
	Tue, 15 Oct 2024 11:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992832;
	bh=CneV3B0iEK//hM1XR1rhzHrd+cRckaJPzIzBeXmOhIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWs2DvNCJmn2hQVhqFCWkz0IJDmo6/UYqHQcRtBAqHBllei8s6BrZUuRqhjD9RIa6
	 cxBVFaIop6Wn9h9C+sq+/ILDcyU5IFQ2aAaaN5PW8Llld0n2bsQw2eKl6IkEryb2mb
	 tUimDPlTC4WUlYMnNATqyJHPwMVtUdcYU2BCQdpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/691] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Tue, 15 Oct 2024 13:22:59 +0200
Message-ID: <20241015112449.525691241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junlin Li <make24@iscas.ac.cn>

[ Upstream commit 8ae06f360cfaca2b88b98ca89144548b3186aab1 ]

Ensure index in rtl2832_pid_filter does not exceed 31 to prevent
out-of-bounds access.

dev->filters is a 32-bit value, so set_bit and clear_bit functions should
only operate on indices from 0 to 31. If index is 32, it will attempt to
access a non-existent 33rd bit, leading to out-of-bounds access.
Change the boundary check from index > 32 to index >= 32 to resolve this
issue.

Signed-off-by: Junlin Li <make24@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4b01e01a81b6 ("[media] rtl2832: implement PID filter")
[hverkuil: added fixes tag, rtl2830_pid_filter -> rtl2832_pid_filter in logmsg]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/rtl2832.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index dcbeb9f5e12a3..7b0d6be9bf000 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -983,7 +983,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



