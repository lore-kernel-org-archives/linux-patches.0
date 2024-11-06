Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495751DE3B9;
	Wed,  6 Nov 2024 13:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898139; cv=none; b=drMhxqHSrvd/6+oVYIiwQ6bWCXn55qpgGSDwqqa+Hr0ON9YwCImIl+fnBKoO6j15z/nZ3wQJlsanYBkdGSUMDAHDIMtxA4IBaG94vCD+locwpeZRxi9CFg7kbzqxgj8vHUSIfgewG4hSGh3whOu2UbUXmLnMESASRilY0dx1fAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898139; c=relaxed/simple;
	bh=+mHnpXBUpXhMzSMMZT/fNkE/oLxTDostQdfoEJdhi50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSlyzMdgQEbjholmIpvVrww9vwYubh6kcffkUITqWAqM8ehDlggkqDC/tyf/5x1I8LECEOZX25NoAgc0qI+OhNpfyW7GB3GIWkadPACKcdoNfriToG2RXLbSWz1S8ntP8z0jmGiNHHPLkh+SoLk6hsrXyJTEhKksZCa61PeFGIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi6NUKN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi6NUKN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50D4C4CECD;
	Wed,  6 Nov 2024 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898139;
	bh=+mHnpXBUpXhMzSMMZT/fNkE/oLxTDostQdfoEJdhi50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi6NUKN2AxRRq6gcjLMw6k8aovZQwt9I/YXmQ6AbX8/tj6Y2ncrEY5N8HooXNZJbi
	 PseNfaoa4EXRwp5dofxdUvM9/R3A454DvgmqWD0EztMshwZd0cseWJpL3cq8a4+56E
	 y803usRJgb2qGTabcQ22wZzZpSovCfoNm3dImY7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/462] drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
Date: Wed,  6 Nov 2024 13:00:03 +0100
Message-ID: <20241106120334.223523131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



