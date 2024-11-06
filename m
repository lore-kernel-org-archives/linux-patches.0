Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77101EC019;
	Wed,  6 Nov 2024 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898107; cv=none; b=QfKFHJu4esLd21Xo8v1Szh2KyUaZl24c0VEUz9K/5jtq38PKctdGBgFUfMWlGXqWvV40klTZZz/ix4NB4Pcm6utTQjp2YkyVMKK1D7VWX166lSsWtM381H8bnLU6qaThxAu+iLaGWZE9Kdi0tB+GWMLWh/muPq4Qp9kMDL2RFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898107; c=relaxed/simple;
	bh=pVLKGvD7sEOsydIYTTfT2abDWa0b7ap7FpRgetbWHZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLCriDipwtyQ5WumTTRwHTvMlFddbghYhw3KfauvPY0MgOYlIv5N5lIq4cmjlGzgn4Wzqu+Yt0RMpMvC5bMywPzzo/oTxUUX1TOx/5dhovhykYI9LWDQ6qs9ET7lbk2SjSQCbz/O8Dhpoflp6RMXpbLo+sHiSUYOzd5eiE6CqiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDJYNmLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDJYNmLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEA9C4CECD;
	Wed,  6 Nov 2024 13:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898106;
	bh=pVLKGvD7sEOsydIYTTfT2abDWa0b7ap7FpRgetbWHZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDJYNmLGa9WtjzviG0ZKEprYqk+Xh5oF14mXQGU6DObjkSRs76PjhSX4i1BXBd4jc
	 WrFSB+mlG1zt42ymOCIW82oglK6cw92h9JuPx5/KzJcQURLagNg0q2mx1mzYlkUxEo
	 udiB32zd+My4rEuqkbSjSv4VcA4EHsA2YcTAyQ70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junlin Li <make24@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/462] drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
Date: Wed,  6 Nov 2024 13:00:02 +0100
Message-ID: <20241106120334.200255577@linuxfoundation.org>
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
index e5bffaaeed38a..1c3e572cad3fd 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -982,7 +982,7 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
 		index, pid, onoff, dev->slave_ts);
 
 	/* skip invalid PIDs (0x2000) */
-	if (pid > 0x1fff || index > 32)
+	if (pid > 0x1fff || index >= 32)
 		return 0;
 
 	if (onoff)
-- 
2.43.0



