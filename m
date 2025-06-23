Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BE2C2E0;
	Mon, 23 Jun 2025 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714260; cv=none; b=LZvE0D/IJGe9VwUU1AdE8lmgqJHp474/iSVu8vY6id1kaNgSyIouoqjCWzy7I0lh8E28pPtRigArsnmFwmiURRu/7WKthu4Jn1GQl57Lr4wPW7fGQWdJursA2wsRFwC3JTrY3UJX/+NdKL7yeJksF/hcGrJOeLt94f5IhhecBvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714260; c=relaxed/simple;
	bh=/z1E7ggWWXQDC3Z72icq/zr0CpsZelT/HrD6MlQ444A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTI6xYU4suekFjFNJhimd97OSNRQo+NaVRB2nXh0p9d/c4qPcLTw6jLuIorevwJipeK1aJRrtMe+D9t7r7xPcROt7U5dE1DP3d0IFbblkRpgPxTDbqZgqTF037U6VsqOWvDbcyrc22D8SMB+Q2xHHIASG0kzXXa8UL4SN8ikjxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrOwTF1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrOwTF1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4598C4CEEA;
	Mon, 23 Jun 2025 21:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714260;
	bh=/z1E7ggWWXQDC3Z72icq/zr0CpsZelT/HrD6MlQ444A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrOwTF1zikN7dR0bDzSBDgpW++kxfIuhUwX6Fyz16X87d1EzhQZN15bL46P+z8ueK
	 8LvCXddygmdC29Oo1ASsOu1XBZAy3yOk9HNUG+uVV3Lw/ol7Bkp2k2QqgHa3ikBucW
	 WnSxDAMadprYkDThtJFlcxjfbnMYnlTY3FCsFZOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 195/355] parisc: fix building with gcc-15
Date: Mon, 23 Jun 2025 15:06:36 +0200
Message-ID: <20250623130632.534868712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 7cbb015e2d3d6f180256cde0c908eab21268e7b9 upstream.

The decompressor is built with the default C dialect, which is now gnu23
on gcc-15, and this clashes with the kernel's bool type definition:

In file included from include/uapi/linux/posix_types.h:5,
                 from arch/parisc/boot/compressed/misc.c:7:
include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
   11 |         false   = 0,

Add the -std=gnu11 argument here, as we do for all other architectures.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -22,6 +22,7 @@ KBUILD_CFLAGS += -fno-PIE -mno-space-reg
 ifndef CONFIG_64BIT
 KBUILD_CFLAGS += -mfast-indirect-calls
 endif
+KBUILD_CFLAGS += -std=gnu11
 
 OBJECTS += $(obj)/head.o $(obj)/real2.o $(obj)/firmware.o $(obj)/misc.o $(obj)/piggy.o
 


