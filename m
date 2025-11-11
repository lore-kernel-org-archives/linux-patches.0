Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2979A26CE04;
	Tue, 11 Nov 2025 01:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825424; cv=none; b=flFFXay0GhdQH6sw3ff6mcvcXbTbiuKwni36jS7K1fuUjprnQ5RCTHeV39Y5rLLFQk6rN57f8Ae/AsaAb2DvaLKKSZTN4fTmtHkPzZSf9vn+ARNazPDczILnnsTGekjt/Whkjqa4ZG4S//dcZPcO63LUarCdtakxonFD1yPBF78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825424; c=relaxed/simple;
	bh=b2cfvkWSz90q/8oiwsJJT6rcH++g3msIBfPpQrpWmdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZSOK5t+ewxTfUjW8AFALkhbxWYxqL3ZLUsL5IN/OuLeu/eJZJoNwlCwbUWJ5WOIkwLlbUYaJjm+16TTt+rYTqqkHix71NY6h7+m+OM+PRq2irRUXCYd5M9p311RH6DRJYFd2Ve2qOftQ8GvGBvIUM4pg3hUkrLezy1/nLQRH3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNavkdU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNavkdU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92829C113D0;
	Tue, 11 Nov 2025 01:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825423;
	bh=b2cfvkWSz90q/8oiwsJJT6rcH++g3msIBfPpQrpWmdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNavkdU7N6+vs9Evf33Rdc77ocbieLrhP57o3egMUAx9nMZCZxocsl0+CAg5VWd9u
	 QcVz1cf1clUf/1eRbYn0HBWtF/YhBdff96aM3q1CBRFMtHZSz2XWOkm4huYFzWWcmC
	 U9rByOBO1kk7l3tzvDVhKm/IKl/b5bF0czrVwicA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a546141ca6d53b90aba3@syzkaller.appspotmail.com,
	Tim Hostetler <thostet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 759/849] gve: Implement settime64 with -EOPNOTSUPP
Date: Tue, 11 Nov 2025 09:45:29 +0900
Message-ID: <20251111004554.784138922@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Hostetler <thostet@google.com>

[ Upstream commit 329d050bbe63c2999f657cf2d3855be11a473745 ]

ptp_clock_settime() assumes every ptp_clock has implemented settime64().
Stub it with -EOPNOTSUPP to prevent a NULL dereference.

Fixes: acd16380523b ("gve: Add initial PTP device support")
Reported-by: syzbot+a546141ca6d53b90aba3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a546141ca6d53b90aba3
Signed-off-by: Tim Hostetler <thostet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20251029184555.3852952-3-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_ptp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_ptp.c b/drivers/net/ethernet/google/gve/gve_ptp.c
index 19ae699d4b18d..a384a9ed4914e 100644
--- a/drivers/net/ethernet/google/gve/gve_ptp.c
+++ b/drivers/net/ethernet/google/gve/gve_ptp.c
@@ -33,6 +33,12 @@ static int gve_ptp_gettimex64(struct ptp_clock_info *info,
 	return -EOPNOTSUPP;
 }
 
+static int gve_ptp_settime64(struct ptp_clock_info *info,
+			     const struct timespec64 *ts)
+{
+	return -EOPNOTSUPP;
+}
+
 static long gve_ptp_do_aux_work(struct ptp_clock_info *info)
 {
 	const struct gve_ptp *ptp = container_of(info, struct gve_ptp, info);
@@ -55,6 +61,7 @@ static const struct ptp_clock_info gve_ptp_caps = {
 	.owner          = THIS_MODULE,
 	.name		= "gve clock",
 	.gettimex64	= gve_ptp_gettimex64,
+	.settime64	= gve_ptp_settime64,
 	.do_aux_work	= gve_ptp_do_aux_work,
 };
 
-- 
2.51.0



