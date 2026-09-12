Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C853F45629C;
	Sat, 12 Sep 2026 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211625; cv=none; b=ZByLVszjAGnFruEoZHl87VzloGAmYhZtOmrZfSNSB33eDTYSuJbJ8xG4JA4qmYUq0M9BnqPZJILN5JF8sTlJaJ1uwT5OkLfFiaXQXyqvG2DRaPR2aJpMTht5z/Vgxz+U+xNlLved8yQvv5ZzEgUxg9CZ+NHG1GYB6tWoWAwCcp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211625; c=relaxed/simple;
	bh=JPB++TL8gpa/MrS3/KyKM4I3jFssg2NkshGFK8D6dX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8nC2YQkL42zrXpfo/OWhVn+Jn9B1c5AG/O0H0aiXb8QKsyifl9J/b+GZzPF5qyCmy2bj5vav2USYN4mTOjHFYw7EzdOyfZ5HCZZRRAiuxJjH1+HXnZ9gcRD5cJPjrkhS95FzftfhFSUVGUa4XzA5Mm43OuNqktJwuES9zhFw98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dgjovbb1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dgjovbb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF08E1F000FF;
	Sat, 12 Sep 2026 11:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211624;
	bh=xqZcVj4IqP3jS9Mxy4LkH8SMg8rG4AEw3spwCZj5NHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dgjovbb11fLR1aEVIibusEsckbZ26/jVbs5EQX06cHY1tzF8+8YT0R3CzkZmgq5WF
	 2+DZ035QWq0e1QmEUG0SpyYn7kwdUZR7c5HnXNU+H25iV6vMUj+kkHAzL7r9JJdbY1
	 E4CKKdmjiJ4ZItSq95mwAlCq2YkV8N907nfuMfgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joas Antonio dos Santos <joasantonio108@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1268/1518] ipvs: fix integer overflow in ftp helper port/address parsing
Date: Sat, 12 Sep 2026 08:57:17 +0200
Message-ID: <20260912065652.195245601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 206c6700e2006..d3be352a5ea8c 100644
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



