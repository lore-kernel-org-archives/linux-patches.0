Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2220A19B3FF;
	Tue, 15 Oct 2024 11:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992836; cv=none; b=SQ5JJ6dVx+SpbrFH1ihpsIbjvHbzE9Zfmr9Wdj1W1Di2s3dDYC8a/q+IuKBuLBTP14t/IH0DXqqze5AQlQH5mBUN+hIifD69PEAsHGBsFkMq/VHYTy9gRsEMQmOw2rhS3Y5stMUpqNY/AB+H2+F7EN6NfIyYrTpVZuAbIFvmjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992836; c=relaxed/simple;
	bh=01hUSxMt/bogjYDaM6AjHB1Ykwcgr0oHVNmPCpnxILs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqEhfXD8uLyFCM3bjEaS6/DENaM416QJEOlftp+RYbA1PWpfpg0v/6dGQ072FUUrCyFnOiTevihPQtPrvXkZiYyitknZxOZ6LBmf5urLVZgFnnmLTiQUtyy3aKGMXWOJGn6kSFks4xOgf1f+77qSRbwojCx0VUzvfPqc3acNJQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBWiL3d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBWiL3d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85210C4CEC6;
	Tue, 15 Oct 2024 11:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992836;
	bh=01hUSxMt/bogjYDaM6AjHB1Ykwcgr0oHVNmPCpnxILs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PBWiL3d7tCNW5xVqdizMX4KgFt3oyySCtc7VWcJkfhiv2beMtne4AGaXALWEybuQg
	 z6TjTn3lN3J64wFlnyLjf7UpVBmFEUMZwdkvuTKMS3saRPtxKjTCdo0v6eDofdPtnf
	 hb3c19v2W6i4/RlXqLscL+PoxB+a1OLIeA7Is+NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/691] drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
Date: Tue, 15 Oct 2024 13:23:00 +0200
Message-ID: <20241015112449.566627136@linuxfoundation.org>
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

[ Upstream commit 46d7ebfe6a75a454a5fa28604f0ef1491f9d8d14 ]

Ensure index in rtl2830_pid_filter does not exceed 31 to prevent
out-of-bounds access.

dev->filters is a 32-bit value, so set_bit and clear_bit functions should
only operate on indices from 0 to 31. If index is 32, it will attempt to
access a non-existent 33rd bit, leading to out-of-bounds access.
Change the boundary check from index > 32 to index >= 32 to resolve this
issue.

Fixes: df70ddad81b4 ("[media] rtl2830: implement PID filter")
Signed-off-by: Junlin Li <make24@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/rtl2830.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index e6b8367c8cce4..84c00c6894d3d 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -609,7 +609,7 @@ static int rtl2830_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid, int on
 		index, pid, onoff);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



