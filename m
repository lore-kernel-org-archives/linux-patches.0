Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5F22222BB;
	Thu, 13 Feb 2025 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457987; cv=none; b=riu/Zdx/mEk9DZ2eaDMCMy5+Lq4slu4H0zCXMHvMd74nRllHsTUY9/Onc7o3sfy5f7vJ18ZZ4sHVQxtCCJXsmRKeib/hbyebrE/1gwqetBEs+bR7VPziKrkYKuXcDaoKGWfvGUuwiDjwVu0EXsdqmRT1vx6eYixLwEHqJ73ASYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457987; c=relaxed/simple;
	bh=EBHmPj3Fl7/8zl6787sDOfKhqbgVR6vcF+pae6e3f1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxj/g3Ro8ccE6I+HxMUbDbUZ0873eP7aOFb1kWHAEi49mWDmaIniLOL2Hrl+u4rw9cIT3UeyaqFa/Z9IID9Drk7U3x8wN0aRPv4gT7e30XClINmhBETw29c0big3vvKd27n09MtnWVft9ZS/DOgXJKNxz6iKlrPWfH5hJ3Oxh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH8DZqew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH8DZqew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBF6C4CED1;
	Thu, 13 Feb 2025 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457987;
	bh=EBHmPj3Fl7/8zl6787sDOfKhqbgVR6vcF+pae6e3f1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH8DZqewN4pdYV5/xnvE9CmTAIY6iOBAY2AMxm4GuFHdImWnCFTlxEYDiHMAkmMk/
	 /lpfVxLghfY+Yup03ObAHzXhceREDx69sbx/O8tEsYh2Qj+G3/QRqlb0FgQ0iH8omN
	 b5jf/OzWq7nMD5h/mXAvBoWxbj9w64gA4gQw9RVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 236/422] MIPS: pci-legacy: Override pci_address_to_pio
Date: Thu, 13 Feb 2025 15:26:25 +0100
Message-ID: <20250213142445.642310438@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit df1b8d6e89db0edd572a1e375f5d3dd5575b9a9b upstream.

pci-legacy systems are not using logic_pio to managed PIO
allocations, thus the generic pci_address_to_pio won't work
when PCI_IOBASE is defined.

Override the function to use architecture implementation to
fix the problem.

Cc: stable@vger.kernel.org
Fixes: 4bfb53e7d317 ("mips: add <asm-generic/io.h> including")
Reported-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Closes: https://lore.kernel.org/r/99f75c66-4c2d-45dc-a808-b5ba440c7551@app.fastmail.com/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/pci/pci-legacy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/mips/pci/pci-legacy.c
+++ b/arch/mips/pci/pci-legacy.c
@@ -29,6 +29,14 @@ static LIST_HEAD(controllers);
 
 static int pci_initialized;
 
+unsigned long pci_address_to_pio(phys_addr_t address)
+{
+	if (address > IO_SPACE_LIMIT)
+		return (unsigned long)-1;
+
+	return (unsigned long) address;
+}
+
 /*
  * We need to avoid collisions with `mirrored' VGA ports
  * and other strange ISA hardware, so we always want the


