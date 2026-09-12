Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80B44195DA;
	Sat, 12 Sep 2026 09:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204256; cv=none; b=kgxdUwQAET5B6+Y8Gemh4tCjPDPN0vrQnFLlYGXNCNY0QVpPku6Lb1s8FtinXIHDbOy3TIwMorLQ2TCdO72aEXNt8quD4hYT5jW+WGe3J7k6KZDrJi/Duy/JpuUZ69ucXc/3pjqlDuaenG3ktg9yvElu/w1UyfRwrmHrT7p79c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204256; c=relaxed/simple;
	bh=B31RQ0ZAJT6SK88P9MGxyvc04vzB2zd/9huNR1QbZ+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZ61T/k070hxJUuOOqtgyIST5dWGCoACSPucN/pcMbm7xKdSjBJ26Ahd8u+t7GZ0qVQgZHVrbvprWUQusfMQjBfeA9KQJmtnt6uDDKDfntwDkutXqu2vWeobg8Ggzn9McA6Jm1SVdFRZ0Nxq2ErQRsI9WbcZzWWhkWk60l+VLig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qS9j9d+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qS9j9d+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1241F000FF;
	Sat, 12 Sep 2026 09:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204254;
	bh=VMbXj4rNbJgwCgQ8NTpZwpe/NCUZMtXSFj1IMhhAv7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qS9j9d+vJ+Gd0fSPCJx9//+HrIAhERTeTe0+v9PWEg88lYs6Qx0dLIkav87w0795I
	 f9abwYxWYnx51sn9bf1gdkOhP0jl2C3PuJIS7BI1R+iJDeUGSd8l/xolCQuXQuqj32
	 L+vN6hxwjnxDMe7dcR54oO6+x/smtQmUce8YZrCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1575/1815] ipvs: fix integer overflow in ftp helper port/address parsing
Date: Sat, 12 Sep 2026 08:55:25 +0200
Message-ID: <20260912065725.964354838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

[ Upstream commit e625a9477d12baaff4025c5f9989184a907ea8fc ]

ip_vs_ftp_get_addrport() accumulates decimal digits into a __u16
(hport) and into unsigned char (p[]) without checking for overflow.
A crafted FTP PASV/EPSV response with an over-long port or address
octet wraps the value, so the helper configures the data connection
with a truncated port/address.

The netfilter conntrack FTP helper had the same defect, fixed in
commit 2b413fc689ba ("netfilter: nf_conntrack_ftp: avoid u16
overflows"). Apply the equivalent fix here: widen the port accumulator
to u32 and reject values above 65535, and reject address octets above
255.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index b315c608fda43..9e3e005a82635 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -102,7 +102,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 	char *s, c;
 	unsigned char p[6];
 	char edelim;
-	__u16 hport;
+	__u32 hport;
 	int i = 0;
 
 	if (data_limit - data < plen) {
@@ -144,7 +144,11 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 				return -1;
 			c = *data;
 			if (isdigit(c)) {
-				p[i] = p[i]*10 + c - '0';
+				unsigned int val = p[i] * 10 + c - '0';
+
+				if (val > 255)
+					return -1;
+				p[i] = val;
 			} else if (c == ',' && i < 5) {
 				i++;
 				p[i] = 0;
@@ -222,6 +226,8 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 		if (!isdigit(*s))
 			break;
 		hport = hport * 10 + *s - '0';
+		if (hport > 65535)
+			return -1;
 	}
 	if (s == data_limit || !hport || *s != edelim)
 		return -1;
-- 
2.53.0



