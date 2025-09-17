Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2351F09A5;
	Wed, 17 Sep 2025 12:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112931; cv=none; b=Sy7DUf9dp0AVPujJVDs2y7LTP4BWOnSNM6I+msbjW+ZVoW9x9CFn2TUVGNwObObgQLF3T2eREsfBGgkUm2g+DmWBqTjgCpUPp8jH9J0xdn1KgA2VJjctGeFtRr/vpxq1CavNf5qOuaPhq/K4bTwxQ404iCHUFVkJXq1go6tTfyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112931; c=relaxed/simple;
	bh=akJJuQJfReEojc8noYa2E0Z/xnB+94jSb1qgeAdDwJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uarMEi7FTNm5OGdJ6nVX2O5tRFn+MxAW5k+uruasiyb6SGu1QU2zB85FGRvMhNlxjx62t4ofDJvVnSxnZurSn7Eh3xIq59ZKyzusYq7V1W3y8b2KjzCn/jBLKPbxkVmabt3rwTPL7IPDgpNxrfOvdtrHf/tNrrLDvuA2yTdIoeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gbp8rkvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gbp8rkvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32AEC4CEF0;
	Wed, 17 Sep 2025 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112931;
	bh=akJJuQJfReEojc8noYa2E0Z/xnB+94jSb1qgeAdDwJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbp8rkvCFqEnvmgrw+7jYRWT3vS+zn8/MbuednHZCjc8H/NO25KOhoTOfVs7LofSU
	 Ih/7eVDctDtHTFArDEXGYL4BL824X9L3mTXHF8VMS6FrQ2EwyhgshlvO2ieSQg3amD
	 F/7O0vl7N/nwh0JCECWKyQwO4AOFg7aFRQHkizWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabian Vogt <fvogt@suse.de>
Subject: [PATCH 6.16 120/189] tty: hvc_console: Call hvc_kick in hvc_write unconditionally
Date: Wed, 17 Sep 2025 14:33:50 +0200
Message-ID: <20250917123354.794127090@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Vogt <fvogt@suse.de>

commit cfd956dcb101aa3d25bac321fae923323a47c607 upstream.

After hvc_write completes, call hvc_kick also in the case the output
buffer has been drained, to ensure tty_wakeup gets called.

This fixes that functions which wait for a drained buffer got stuck
occasionally.

Cc: stable <stable@kernel.org>
Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230062
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Link: https://lore.kernel.org/r/2011735.PYKUYFuaPT@fvogt-thinkpad
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_console.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -543,10 +543,10 @@ static ssize_t hvc_write(struct tty_stru
 	}
 
 	/*
-	 * Racy, but harmless, kick thread if there is still pending data.
+	 * Kick thread to flush if there's still pending data
+	 * or to wakeup the write queue.
 	 */
-	if (hp->n_outbuf)
-		hvc_kick();
+	hvc_kick();
 
 	return written;
 }


