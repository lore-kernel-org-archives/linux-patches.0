Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EBE6FB1;
	Tue,  5 Dec 2023 03:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s29C82f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856D7C433C7;
	Tue,  5 Dec 2023 03:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747077;
	bh=Xstxk+IDDB/GiQ+Iu/lXeOs9aVoruyhHQbBybfJyXw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s29C82f8r27qfiOarezKZQIKhQApqD3H+8DdSK4Wx29bHK4uhLbH06en/B4Z2npgX
	 tDBzNorUzE4HtdlPsqbxDYL/gbHtjOGJpN6NfxIOwhUXUxu+mn9nADHA/70gN94iz+
	 H/YnQkML1HmVmtKurFhpY0/uuzTp3+eSZd2HX2Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	David Reaver <me@davidreaver.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 051/107] auxdisplay: hd44780: move cursor home after clear display command
Date: Tue,  5 Dec 2023 12:16:26 +0900
Message-ID: <20231205031534.517148119@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 35b464e32c8bccef435e415db955787ead4ab44c upstream.

The DISPLAY_CLEAR command on the NewHaven NHD-0220DZW-AG5 display
does NOT change the DDRAM address to 00h (home position) like the
standard Hitachi HD44780 controller. As a consequence, the starting
position of the initial string LCD_INIT_TEXT is not guaranteed to be
at 0,0 depending on where the cursor was before the DISPLAY_CLEAR
command.

Extract of DISPLAY_CLEAR command from datasheets of:

    Hitachi HD44780:
        ... It then sets DDRAM address 0 into the address counter...

    NewHaven NHD-0220DZW-AG5 datasheet:
	... This instruction does not change the DDRAM Address

Move the cursor home after sending DISPLAY_CLEAR command to support
non-standard LCDs.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: David Reaver <me@davidreaver.com>
Link: https://lore.kernel.org/r/20230722180925.1408885-1-hugo@hugovil.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/hd44780_common.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/auxdisplay/hd44780_common.c
+++ b/drivers/auxdisplay/hd44780_common.c
@@ -82,7 +82,15 @@ int hd44780_common_clear_display(struct
 	hdc->write_cmd(hdc, LCD_CMD_DISPLAY_CLEAR);
 	/* datasheet says to wait 1,64 milliseconds */
 	long_sleep(2);
-	return 0;
+
+	/*
+	 * The Hitachi HD44780 controller (and compatible ones) reset the DDRAM
+	 * address when executing the DISPLAY_CLEAR command, thus the
+	 * following call is not required. However, other controllers do not
+	 * (e.g. NewHaven NHD-0220DZW-AG5), thus move the cursor to home
+	 * unconditionally to support both.
+	 */
+	return hd44780_common_home(lcd);
 }
 EXPORT_SYMBOL_GPL(hd44780_common_clear_display);
 


