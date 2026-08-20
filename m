Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3B23B6BE5;
	Thu, 20 Aug 2026 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239305; cv=none; b=HH6OLFhDBV0o9UNvGS+FIh+A/b8R723QIt40E/8Bkyh9jJXWOO7/BbzF5ZhJDOF3+BvxsLOr0MjBiJ8nGalHBau7nUCDaK4nwL/3JXIY4PbMbltJln7sRNF/5M4AvNoR1ewkks3YTjhKXWnFOEx5XS2XNP3Msi9xE49uGLTPYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239305; c=relaxed/simple;
	bh=nY4d1Xdz5koa6lu+JTvWCMN8x+SBnkql9CGRvWS7IWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvtuBx6tpRg2EqPZZOgarzzQmmMKzO1x+ajKUj+G6PEiwg8qM07Vdz+qe9hhpHncQ9IV8ryDlZEzLAJEpE5gVZvgMb9ZJ/ASYzhVzUy6u/cYDTYONUz+GGGBA9F1NlKJhL6tP/plIXFlt8/4PaUabG1Zipa7UiAz8WFEI25F8hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoe34Yqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoe34Yqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E93C1F000E9;
	Thu, 20 Aug 2026 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239302;
	bh=cB66M10/SB9opMUpZLZNg2rIg4Qf79FoJrJCRI/L7AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoe34YqoQ1ZPy6Z4fQpKCUOPRytGnxWYSXQO1C4GzZ6oRKFIhhUPiPIC86BPF6GZL
	 f1dfXkCIIzSYFoJK2rE3qJuEtgWvifrJ9wM3hloeaeg+vatkn7nD82QDE4Snl+79Td
	 NGE8aRhSeUuL8PgCUNLEDYz6aTWEzqcvGi2njjyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/217] drm/log: Fix out-of-bounds read on empty message length
Date: Thu, 20 Aug 2026 16:56:15 +0200
Message-ID: <20260820145243.930339503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 60baa179ed1333535f6e2da4133511db55278ee4 ]

drm_log_draw_kmsg_record() accesses s[len - 1] to strip the trailing
newline, but len is unsigned int. If len is 0, the subtraction wraps
to UINT_MAX, causing an out-of-bounds read.

Add an early return when len is 0.

Fixes: 25e2c2a3eff5 ("drm/log: Color the timestamp, to improve readability")
Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20260729084520.688087-1-oushixiong1025@163.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/clients/drm_log.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/clients/drm_log.c b/drivers/gpu/drm/clients/drm_log.c
index d239f1e3c4563..0ac97550fc619 100644
--- a/drivers/gpu/drm/clients/drm_log.c
+++ b/drivers/gpu/drm/clients/drm_log.c
@@ -160,6 +160,9 @@ static void drm_log_draw_kmsg_record(struct drm_log_scanout *scanout,
 {
 	u32 prefix_len = 0;
 
+	if (!len)
+		return;
+
 	if (len > TS_PREFIX_LEN && s[0] == '[' && s[6] == '.' && s[TS_PREFIX_LEN] == ']')
 		prefix_len = TS_PREFIX_LEN + 1;
 
-- 
2.53.0



