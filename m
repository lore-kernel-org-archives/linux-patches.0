Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8412239E8B;
	Tue, 26 Aug 2025 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216457; cv=none; b=QKd1jvMjpgLs9nuT0iMLZJo/BuUoXk3XU5EtAcY2KCdRNGctCGYR3aFE+Rkg6VVnRvpHrwoV5vcc7eizyJjCdjKmihhseXDQIEPWQZju6U24JMruPE0d4v0JhMpNSPKZu+OFmZPRmcWTP6U0n6+mvegPhX6q8xOJQm6YAzFcbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216457; c=relaxed/simple;
	bh=XO1EPy1TaU83QxriFoKke2Q8z6uFDO9spDT732cBXm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2i6Z/hD1tnew3VgmiK+v8PS+pXHCJcSUj/+yxokYNxeMw1TnVeKvjuzuFZhz35kcESElbnlBm2ATkvi0NyT58EcL6h2r5LV+0pSx9DsEYMgLTDt1Hu89ZRNs0qzvsC53o+l5kKSNttRkIbjh6q1E72qjV0KKQRv8eBEmBhKGwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pxamc5oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pxamc5oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BB1C4CEF1;
	Tue, 26 Aug 2025 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216457;
	bh=XO1EPy1TaU83QxriFoKke2Q8z6uFDO9spDT732cBXm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pxamc5oRzO5MYug5b8lEP47UpEq9bScMj/tOqB8GIlZD9uxbOy96xJ7uLpCRZy8sW
	 wX4vdUkEM+mauKOWEPQ6a5wEZg8szp5FK9BjjYZSX/q3pt8kCOIGeguHGseeC8z3Pd
	 oaYtz3DRcyRXBy3/zWLGgbDUYEUjcGOoOrybSQdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/644] kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c
Date: Tue, 26 Aug 2025 13:08:29 +0200
Message-ID: <20250826110956.817069163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suchit Karunakaran <suchitkarunakaran@gmail.com>

[ Upstream commit 5ac726653a1029a2eccba93bbe59e01fc9725828 ]

strcpy() performs no bounds checking and can lead to buffer overflows if
the input string exceeds the destination buffer size. This patch replaces
it with strncpy(), and null terminates the input string.

Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Reviewed-by: Nicolas Schier <nicolas.schier@linux.dev>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/lxdialog/inputbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 1dcfb288ee63..327b60cdb8da 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -39,8 +39,10 @@ int dialog_inputbox(const char *title, const char *prompt, int height, int width
 
 	if (!init)
 		instr[0] = '\0';
-	else
-		strcpy(instr, init);
+	else {
+		strncpy(instr, init, sizeof(dialog_input_result) - 1);
+		instr[sizeof(dialog_input_result) - 1] = '\0';
+	}
 
 do_resize:
 	if (getmaxy(stdscr) <= (height - INPUTBOX_HEIGTH_MIN))
-- 
2.39.5



