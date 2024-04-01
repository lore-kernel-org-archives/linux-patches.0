Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817DD1CA8F;
	Mon,  1 Apr 2024 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987378; cv=none; b=dGKf77l6PHeekDrVTMXc+XE+HUVq98Phywh0lSbqFIP9dAaBcpKDCSTI5kJj0ry8PyQXF47FbCosT9eY8zY7RqWaFL+9TBF5Nkz0f98+ScCVx8d5V1PvVMokKnaB8EINRMLRJQk6vwzWvLu7FOICd/yoCtoRTFCmu5xsj9P2bRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987378; c=relaxed/simple;
	bh=4lj9MVG/yg1TcwVhqWNMq6GFWKRb6BQ846MtqugpA9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR1vIpZ/qXriCsiI+c7xl7USRE+KDEzIIstqqCjW11+CqbBLzp5c9rRNgaVE+QjZcK8T98T50CPyKF+kLhIVfMpRXF4Cf90xB485T7ZVjogtyFJddy7XTiaMWfK+J2HOMFkQ3b7DJx7Oq9MPqjFZ8ps2xaNCXp+0Ti3wyK+lVq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTJ1Y0kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTJ1Y0kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7581C433F1;
	Mon,  1 Apr 2024 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987378;
	bh=4lj9MVG/yg1TcwVhqWNMq6GFWKRb6BQ846MtqugpA9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTJ1Y0kRAbI/frmCQCsblfhN6GOrk71L/ai8e1vzh6CJZ7RAeoi4Dw8y6V5TNrrdG
	 oITlG4uHw2FXhEB7Wi78ML/QsI2sLaAhoxBklRhTi3XG4M3LtES23H8BMg0NuvOzxs
	 JqqFU23ILwTV1+c7JLKxm0nxdvj7+rCo8DBbekpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Tymoshenko <ovt@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 270/399] efi: fix panic in kdump kernel
Date: Mon,  1 Apr 2024 17:43:56 +0200
Message-ID: <20240401152557.244363076@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 4fcda50acfa4a..1ea14e86a741b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -203,6 +203,8 @@ static bool generic_ops_supported(void)
 
 	name_size = sizeof(name);
 
+	if (!efi.get_next_variable)
+		return false;
 	status = efi.get_next_variable(&name_size, &name, &guid);
 	if (status == EFI_UNSUPPORTED)
 		return false;
-- 
2.43.0



