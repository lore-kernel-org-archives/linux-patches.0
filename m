Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C23634CFAC;
	Wed,  3 Dec 2025 16:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778760; cv=none; b=EWOtq4tv7eEQDpUWyW5Rnvljff3RrQx/yzOtl6ProROA59i1n88YqYIYaOw3h436+hMH8Yrlg+EHbETR2ZTBZKG5W8+FQdaLn/F8KG7Pxcc/b5olUKc7uG0uZfrAYjcwQ+QwjAbu6Oe8w2AxYwISr2wsQmEdktFCuneOFJxDE8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778760; c=relaxed/simple;
	bh=TGPKAyrGweRfreWa9DvlSnAy25J1YSVTvOGuCQlMN1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+FsmA6UyoWbKqBX8zOgFfH1qGuTopgLXTRBqrZ+3WXBDIbM+CNFFQq9prPYcTr93rlocRgTLb97iRnqobimjQGSYejdwcljuM9tBdh1nKiTq4r3zWEQqmonisfRyVe1RhEPBoRQeeGEll6aZyRJ9sk502c6pw2+5vCxOYKzqAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/bxUXF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/bxUXF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837EFC4CEF5;
	Wed,  3 Dec 2025 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778759;
	bh=TGPKAyrGweRfreWa9DvlSnAy25J1YSVTvOGuCQlMN1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/bxUXF0oX1owO/JtNrGvwheyjavpD9alG1b1e5g+becqwEe1rBcGSub6DDLxtHTd
	 V+5fNCLqCyYqoZrZ10Ae1bztS3wJkEM9SrQ+F7q3/aa1oDY7ff/ouiyHhO1iRXILWx
	 F34IO6gOW+cJboG4FqMe6jwrrkKzmsx0Ox5otD60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/568] Bluetooth: ISO: Fix another instance of dst_type handling
Date: Wed,  3 Dec 2025 16:20:52 +0100
Message-ID: <20251203152442.523893636@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c403da5e98b04a2aec9cfb25cbeeb28d7ce29975 ]

Socket dst_type cannot be directly assigned to hci_conn->type since
there domain is different which may lead to the wrong address type being
used.

Fixes: 6a5ad251b7cd ("Bluetooth: ISO: Fix possible circular locking dependency")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index bf7692e15deef..7d521ffc66767 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1487,7 +1487,13 @@ static void iso_conn_ready(struct iso_conn *conn)
 		}
 
 		bacpy(&iso_pi(sk)->dst, &hcon->dst);
-		iso_pi(sk)->dst_type = hcon->dst_type;
+
+		/* Convert from HCI to three-value type */
+		if (hcon->dst_type == ADDR_LE_DEV_PUBLIC)
+			iso_pi(sk)->dst_type = BDADDR_LE_PUBLIC;
+		else
+			iso_pi(sk)->dst_type = BDADDR_LE_RANDOM;
+
 		iso_pi(sk)->sync_handle = iso_pi(parent)->sync_handle;
 		memcpy(iso_pi(sk)->base, iso_pi(parent)->base, iso_pi(parent)->base_len);
 		iso_pi(sk)->base_len = iso_pi(parent)->base_len;
-- 
2.51.0



