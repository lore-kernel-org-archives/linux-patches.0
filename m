Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D30563D5;
	Thu, 15 Aug 2024 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732501; cv=none; b=NJ/y5UnB4oZbyRoLPb/P5aL9tCf0nS4JFyAJYV+J5+aO70n9oUgKP/a1KgewN4ZsNEi4vErwY1ZvFGm/gEELcfDBYLJYGHMziHMiJey0NRMU3Oad0STcW0RtFaXYVKiilqYWAKR7A0gumLSTosXNKwCl5hfGklDoSkgwpSgiNmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732501; c=relaxed/simple;
	bh=/GYFMd0lg22rkAUA2TczJdOzWFVcoivEWUDe4yp7Ewc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDT75oGZ9KWGAMLDUgrwib07JV8vQC6DeanuOOtCh64Sqme3QHfv8kQ6Un+xel+Wv79Mw04boeeIWqNms3CudohJ/DG09uHKRY5BWteXLoIrgQ0heiwajE23ZAAdG3qPr3joyH+FWiOC7MIl7ezzorloBryACB8I7/F8XOWXzZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPahCeGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPahCeGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F430C32786;
	Thu, 15 Aug 2024 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732501;
	bh=/GYFMd0lg22rkAUA2TczJdOzWFVcoivEWUDe4yp7Ewc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPahCeGJffZESLIWZ1aG7LuWXX+tAF765/Cxgtoz9zWY2OJp4oezNwGK/PwQhJJ2L
	 wk/k4kyHQFpAVgLtkLG8llcGxzCk7zrcU3OKyTdyDgNQDnbQMKup+zI1LQR6bGrjX7
	 xh0mDIdSyCYEkizzHS7z+zFngDTL0ODH5Bizp8Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/352] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Thu, 15 Aug 2024 15:24:25 +0200
Message-ID: <20240815131926.969523018@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit fa96c6baef1b5385e2f0c0677b32b3839e716076 ]

tipc_udp_addr2str() should return non-zero value if the UDP media
address is invalid. Otherwise, a buffer overflow access can occur in
tipc_media_addr_printf(). Fix this by returning 1 on an invalid UDP
media address.

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@endava.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/udp_media.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 3e47501f024fd..ec6d7730b8522 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -129,8 +129,11 @@ static int tipc_udp_addr2str(struct tipc_media_addr *a, char *buf, int size)
 		snprintf(buf, size, "%pI4:%u", &ua->ipv4, ntohs(ua->port));
 	else if (ntohs(ua->proto) == ETH_P_IPV6)
 		snprintf(buf, size, "%pI6:%u", &ua->ipv6, ntohs(ua->port));
-	else
+	else {
 		pr_err("Invalid UDP media address\n");
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.43.0



