Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BF2195FE8;
	Tue, 26 Aug 2025 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213240; cv=none; b=p6orAg20Jj6Qvlw5FctaP4dHqQrGdBvQcIVWnzaJTkudWdFYVQl4F/BSG8I/JO+YeY0w0PXwhw8jh0Au8Dmhf5VZciA6Dz0xUAmSX63I01pHrrMu2xpKoDsf6oK25C5eIubT8Q0k2bmm5tq3u3LQMbCVdzqyomaY79OMA8mdQV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213240; c=relaxed/simple;
	bh=yAnHOfRxjxc939EedaK8Pixwn3yHDCH3HU4NsOm5s+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMTnZwF4fkhNEPDQQoPqOD1h/k3jO3R2zaYIZumsmIoRwHfZjIjUDNrPSij0jJ6BFVNgvdbGOfdN07zlyG5bWTXiP/HB5BhYDtXlihRCYywVcUD4eDvV7hGnGf5qVu4HIpIGERXvbiKK9OIMb7aGcot675JZWFol4JJLjMM3Lus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqTIIEfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqTIIEfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F4BC4CEF4;
	Tue, 26 Aug 2025 13:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213240;
	bh=yAnHOfRxjxc939EedaK8Pixwn3yHDCH3HU4NsOm5s+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqTIIEfrQlcQ9093vN6lh1O0VenQJZ46pHD22RkYKIDi/YO2S2jGcOz1vn9V3C7gr
	 qLAw91yLJtU79TpIYnc3E+/FUO5edGuD9fyDXlAZbwTGVFWlZouhLTP4PWmc7I+bnN
	 RPq/mlTvG7sJiy3ir/yuGhlGjO8E3o6gJc1nsAjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/587] kconfig: lxdialog: replace strcpy() with strncpy() in inputbox.c
Date: Tue, 26 Aug 2025 13:07:03 +0200
Message-ID: <20250826110959.897587065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



