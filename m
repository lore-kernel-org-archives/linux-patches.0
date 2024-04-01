Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C184C630;
	Mon,  1 Apr 2024 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991202; cv=none; b=etcpMJHKicwJQ+P6o22RW6zAYERhXExRtA+SYjkRCSHiBygRls5dEWHBuWRa1AB4TAMT3a7N69B3e+3MrhlKm1FS8sovfDIaFFxlpPDjXUijFjcw22QeZaq7cOxl2VF8TbTOvQjMSPBJXT3V8qA3FKw/xJIta9ou/HzSbuV3uOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991202; c=relaxed/simple;
	bh=2XOocoDhBODkIhyhuZTDPc/9U13rBdO7VAgqpUE9wz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A77CXd+EbEhEETiMCJUcZiW95F+OEKz/FZ7uwR5q+Jj51joA/x0hWj8pHGQO44+90+5c6mf5WrjkFG7NkkQuj/xEStX/ByGk0P5t9ClZu15yt25xXyLpZrHMHHRImM0z1IUu9BtdB42qQvqTW7d33adV5aKVG3JcQp+Y1Um+XUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGkaQ/un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGkaQ/un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF57C433C7;
	Mon,  1 Apr 2024 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991202;
	bh=2XOocoDhBODkIhyhuZTDPc/9U13rBdO7VAgqpUE9wz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGkaQ/unfkndTOM3QI8F4WVGYwqNA7FruDC0eHMLZFdQ+ABOZtlC+7mM53lIsudfN
	 hQj6cPh6BBkv/3gtgWznpxmMd2XrjKj1UsLqubvIDWeo6Q3ZQEOxM03l39+96ofplo
	 r7jX8HjybDPmvl+OWHeGPW6swXwMrIOFzH4AzoRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/272] efi: fix panic in kdump kernel
Date: Mon,  1 Apr 2024 17:46:24 +0200
Message-ID: <20240401152536.941232311@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Oleksandr Tymoshenko <ovt@google.com>

[ Upstream commit 62b71cd73d41ddac6b1760402bbe8c4932e23531 ]

Check if get_next_variable() is actually valid pointer before
calling it. In kdump kernel this method is set to NULL that causes
panic during the kexec-ed kernel boot.

Tested with QEMU and OVMF firmware.

Fixes: bad267f9e18f ("efi: verify that variable services are supported")
Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9077353d1c98d..28d4defc5d0cd 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -194,6 +194,8 @@ static bool generic_ops_supported(void)
 
 	name_size = sizeof(name);
 
+	if (!efi.get_next_variable)
+		return false;
 	status = efi.get_next_variable(&name_size, &name, &guid);
 	if (status == EFI_UNSUPPORTED)
 		return false;
-- 
2.43.0



