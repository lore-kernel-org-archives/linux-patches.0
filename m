Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25731157A67;
	Mon, 16 Sep 2024 12:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488356; cv=none; b=X35ODaAm2J2l5XT1DVkuzlfnh8qBVs9Jb2b6xenmzw3YOuEXJge32AVrEUGMvd//zxecGf+WQOR4moPdya8o4BTuEWQOHE2i0/fy1R1fk17abYYWGjxAy3x6jOsHN775IE1WnbtiVz6wPWksrvL2KKVWgkspWhEmu7+hwMDNICI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488356; c=relaxed/simple;
	bh=DGTuhztM5LuDjTu+x87m2AHjwHWNJn+n1HIcQOJheds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPNpxhk/YxyukZmw2XJSJJZvuZnwK1qg8/zBv0OYjhBny49CPS6+1X71z/otF3bq0U4eV+JySyLQAxcGof8mXhtOQioSdU9Vtd9lN/jahjGvgd2MXDsFz2l+DVounPqwD1Xy87ZaciLyojGAjk2GDUhztnq1OIfUxcQqDeTaPgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNlYLKai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNlYLKai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B07C4CEC4;
	Mon, 16 Sep 2024 12:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488356;
	bh=DGTuhztM5LuDjTu+x87m2AHjwHWNJn+n1HIcQOJheds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNlYLKaiuN9dmF9/7iiDn7VZxsuk1TwTx4Tj4zSWp8fPzCBuQtYroC1xVDzbzvp50
	 93gc/7oss4Q7jj2RWo6yNdRI+PcAD0Q5vP0QUKEmnpM12v8+uq7+HhUdCtDY7ptXdw
	 AsZtwRIrPm9sFH0rN675SpusWQSIoVCvOEXdkN5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 084/121] fou: fix initialization of grc
Date: Mon, 16 Sep 2024 13:44:18 +0200
Message-ID: <20240916114231.926492587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 4c8002277167125078e6b9b90137bdf443ebaa08 ]

The grc must be initialize first. There can be a condition where if
fou is NULL, goto out will be executed and grc would be used
uninitialized.

Fixes: 7e4196935069 ("fou: Fix null-ptr-deref in GRO.")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240906102839.202798-1-usama.anjum@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index 78b869b31492..3e30745e2c09 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -336,11 +336,11 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 	struct gro_remcsum grc;
 	u8 proto;
 
+	skb_gro_remcsum_init(&grc);
+
 	if (!fou)
 		goto out;
 
-	skb_gro_remcsum_init(&grc);
-
 	off = skb_gro_offset(skb);
 	len = off + sizeof(*guehdr);
 
-- 
2.43.0



