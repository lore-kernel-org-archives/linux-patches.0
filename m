Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFBC30DD2F;
	Sat, 12 Sep 2026 19:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240330; cv=none; b=Dmpgs4C2DmNF4xsJOFaq1kDF04IjBlr6oHYWrQCPvRcgeP51gHXoTj+rNOu6zGOX88NSBuGPm7wDneNLfuV0BYitg8JxxfV+tm/KMe3/bJA45oz+NP8VbvIkGBG1ceUzErPTW9T6hl/oVRxsv6InnY6EnZB0sASu+f3U2qX2/sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240330; c=relaxed/simple;
	bh=6CXu9GhJzY0M+CoEIYj08/X4eMeP8KOWY5fComkf9UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjAZEv89LAtjGJU8DXHA75pPpDACScJPzMzRYzejTPpFCQt/b9pocrg1rc3FVEsM1F141Be0IT+2I4n2j+jaH2mjmu5lA2F1aPvtMnTtsSXz+Zq2EaAjv8VPHxt6LH7m1hY0DdHHj9B9AlGablyHPWqbG3hzrskw9cwpGkGm+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iO/WPzM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iO/WPzM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C054F1F000FF;
	Sat, 12 Sep 2026 19:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240328;
	bh=Ynf4wZ1e+CtIh9Qvj/X40OQL4JRSUf9tRzg/y18Pc6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iO/WPzM2pOjzI7+lEVb4rCYdOAzHN1Aplm1XU6Lh9Qae1l82SaPvSRih1fLveoB5q
	 az8U6pDTFwActUQy4KcNeJ4HSSPl/h1BMoBhonxuzIxnTO9tm/jjFXfQ+YcC6VG01m
	 fu8OjIhsv8F+cfZS/LTTDrSfsKu8aNAgbD3v4AmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 845/935] ipvs: fix integer overflow in ftp helper port/address parsing
Date: Sat, 12 Sep 2026 09:04:35 +0200
Message-ID: <20260912065546.208640723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 61d3797fb7995..b3f0d2d0e1dd2 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -103,7 +103,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 	char *s, c;
 	unsigned char p[6];
 	char edelim;
-	__u16 hport;
+	__u32 hport;
 	int i = 0;
 
 	if (data_limit - data < plen) {
@@ -145,7 +145,11 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
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
@@ -223,6 +227,8 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
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



