Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F381D1F54;
	Wed,  2 Oct 2024 14:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879917; cv=none; b=VdNk0Pwebc9iI6EqMh+OY7BSNVUmNo4qcR0twmucSeH9arFtpi7nA0e7bFAV6FONllm0NXExpeoWtYWxRJHwxNHcSk+Ve4MO2j32ra9lsVK4pMFQXZRZAaPOh5qsjpUvTXK6X1Ix/b/X9/iKmzM4I5mtyIcaAJP3KadTm6jNW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879917; c=relaxed/simple;
	bh=GT3lJMhD9XQAlzMlt6IEizNoL42Ttqdz4uIwH2f13UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbsMQt8MM43DgDb4US1cSDn8BD1oAqi40zXfs4Xc8UT6WKlmZPEAAtLVFjgI1bwnGdjwK/u+vHbJY92idiKOv7U9RICoNdt+LbcI+/H5pvhoZhQ+jcxZJJJau++095PyLnPbl/a+8kQsr10JFCwRszGUU/4uzNhksmfsLs5JcDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+NeYvGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+NeYvGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8DCC4CEC2;
	Wed,  2 Oct 2024 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879917;
	bh=GT3lJMhD9XQAlzMlt6IEizNoL42Ttqdz4uIwH2f13UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+NeYvGuylgFbCdDn/3x69rX3xIFaU7429Ov8x23qYNfAWkaFkvoEpR5rHFG+8lxw
	 pF/BPPyh9jAOvJojNS9mo3r+B2j3szzIolyQgJbcoeS6/3DMhYe42vavHyuShRLdIG
	 uakNlUeW06+Llq9k8uWiBua//V44odGcO2ARZ3Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/538] drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
Date: Wed,  2 Oct 2024 14:58:41 +0200
Message-ID: <20241002125803.386762093@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 35c969fd2cb5e..4e59734ec53e2 100644
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



