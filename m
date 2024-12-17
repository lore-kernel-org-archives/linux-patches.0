Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DE214A4E7;
	Tue, 17 Dec 2024 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456016; cv=none; b=tt6H4ItFqolBJbASoaT/rjWqr/IMgnN/wq4ltWWljsJn8Uv8V1O/36nG3ZGxN1KlXUmkdZa39kW5qQjJGHMwJtRaH2/ZYx10HGtVaowx78wNJrJMlgs/ue2AohtAPf8ma5dWNxT0EEHklZ6/NTnjrpdr/tHiv5gtphjYrYCRymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456016; c=relaxed/simple;
	bh=b+SLI/HPOfCbCjBlXtLSjLQr0P6KefI39CPLDV75Iz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgkMr58tTGnugJwmvra0XBIajM+Y3XkmF0bIoiG545OK/BVP2blAc+hGz/+/elxgHV65bYJCDRZl8p/SwQoKPkCiJ7l/q0DMByxrymLj1NpVq2iTMlOv7RolYrvVVC0+6A0Gc7SJuB4lNY6wHgODaqllAQIsI4AqGVTfyeXr6Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ubf3X62A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ubf3X62A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD7BC4CED3;
	Tue, 17 Dec 2024 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456016;
	bh=b+SLI/HPOfCbCjBlXtLSjLQr0P6KefI39CPLDV75Iz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ubf3X62Aldwi1BQ+2BzK46fxp9GMbCvbGBoyTVOvc7C5GQm6D8TXC9QDxJvoFZJch
	 Aa0DDqRMGqUpUGu53meWhyfRMnmtUYdSk7t03oi3BhkuFRHnYceFxe4cVFaUy8/W6R
	 64gY8qZIFmWyOOA7PJt3zprXcnfR7IniXupXYqsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MoYuanhao <moyuanhao3676@163.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 005/109] tcp: check space before adding MPTCP SYN options
Date: Tue, 17 Dec 2024 18:06:49 +0100
Message-ID: <20241217170533.559975757@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MoYuanhao <moyuanhao3676@163.com>

commit 06d64ab46f19ac12f59a1d2aa8cd196b2e4edb5b upstream.

Ensure there is enough space before adding MPTCP options in
tcp_syn_options().

Without this check, 'remaining' could underflow, and causes issues. If
there is not enough space, MPTCP should not be used.

Signed-off-by: MoYuanhao <moyuanhao3676@163.com>
Fixes: cec37a6e41aa ("mptcp: Handle MP_CAPABLE options for outgoing connections")
Cc: stable@vger.kernel.org
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
[ Matt: Add Fixes, cc Stable, update Description ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241209-net-mptcp-check-space-syn-v1-1-2da992bb6f74@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -837,8 +837,10 @@ static unsigned int tcp_syn_options(stru
 		unsigned int size;
 
 		if (mptcp_syn_options(sk, skb, &size, &opts->mptcp)) {
-			opts->options |= OPTION_MPTCP;
-			remaining -= size;
+			if (remaining >= size) {
+				opts->options |= OPTION_MPTCP;
+				remaining -= size;
+			}
 		}
 	}
 


