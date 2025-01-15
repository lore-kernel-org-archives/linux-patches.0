Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C0248BA1;
	Wed, 15 Jan 2025 10:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938233; cv=none; b=jtATpkAU5pDADKTW2ll+Lb3SRAts/HafGhz2vFxKBw6zpLO6TYT6bKEh1Yn5SodkfAmi/TtcHa2TKA/dBhUN1v7VfuhhONfHsubkA9MZMOuAiWo7ZZ5lKfEQZHI3p1E1/lDImAkKAXrHgNyzGZ6ADGVCtERunGLCX7QoW4QU/H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938233; c=relaxed/simple;
	bh=bARCnv5+psoDtvNkjlflY6CitRatzkpQi1KOAKB9EKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWmFh1G45saWVSkQgtfjJBUDexOa/6WoEkfmXv7am0x/tsVGbL5i90kkzdhwp0BwMIXuqeuikIP3yRpDsdEwHUaNDEqmFhDdHpi8AyObutCnCKzS7wag4yCVB+pwPWCd1YqhOcdrppu3/eJOupXOiYldpU23UDwkKZ9x9kCqNp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCi8lfP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCi8lfP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F317CC4CEDF;
	Wed, 15 Jan 2025 10:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938233;
	bh=bARCnv5+psoDtvNkjlflY6CitRatzkpQi1KOAKB9EKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCi8lfP4XX9pd4HZikU4gx1UmdcO/ziO2gG4M2nZgaftaOqQxdmWorD5aoefwTa90
	 lmdLYd0BlyzaqRrSch/okFuIL4cFuz3Yyr+OHrWRT7Y0+Npmd9G4kHQlyvsIIGOHt8
	 MjWZdUdh3VM2tut1XrvLrf5aldPbYOYn9ydRX6Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 095/189] sctp: sysctl: cookie_hmac_alg: avoid using current->nsproxy
Date: Wed, 15 Jan 2025 11:36:31 +0100
Message-ID: <20250115103610.116274707@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit ea62dd1383913b5999f3d16ae99d411f41b528d4 upstream.

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'net' structure can be obtained from the table->data using
container_of().

Note that table->data could also be used directly, as this is the only
member needed from the 'net' structure, but that would increase the size
of this fix, to use '*data' everywhere 'net->sctp.sctp_hmac_alg' is
used.

Fixes: 3c68198e7511 ("sctp: Make hmac algorithm selection for cookie generation dynamic")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-4-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -387,7 +387,8 @@ static struct ctl_table sctp_net_table[]
 static int proc_sctp_do_hmac_alg(const struct ctl_table *ctl, int write,
 				 void *buffer, size_t *lenp, loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net,
+				       sctp.sctp_hmac_alg);
 	struct ctl_table tbl;
 	bool changed = false;
 	char *none = "none";


