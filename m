Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF89B5464F;
	Tue,  8 Jul 2025 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992918; cv=none; b=Ajum2DN/Rz9OLc9RsSZTfB/3GxRsb5muiaOBsL9Y74SaE8O3OMQhal9HcJSkWnfptoceY4AqG2+paC0KjXN7cg4MIFVy/7cKJ1SJ3/i5lobbgWC5d6cZinUCcs7otbTgj5NB7lMJO5CGV6zaC7LgseiDqjUE3DpAI55RXxP5+SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992918; c=relaxed/simple;
	bh=ZI3lWCEbwHCPa0yi67TkP8eAI7cZRB39mMm8bmEyOwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bbw/ZFdzQwuPEUdeGA0hvUGpI0BXMfrqCZ9/LuBRKEKODLq2m32b/xWJ8KpTDtuB7oQYVtxfHHzZvzSeFGkKa7JYowV18XWCl4wIIgTZzu6o/dUIFKGrC6CQC65wTFPF9KuGCHB3i5d6S3pbFIugi0o2sr251NhR+dqONSZ37go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXY0wDnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXY0wDnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C72C4CEED;
	Tue,  8 Jul 2025 16:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992917;
	bh=ZI3lWCEbwHCPa0yi67TkP8eAI7cZRB39mMm8bmEyOwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXY0wDnklbf70qJ4u49O2NYOXvAy5YVzV5CTznKsaiurpHeyL5pHGW48gRdSkMcZs
	 xxL6RV+C/q2TORZMSjo5mpznB6dpDFF5MKUUSLJwbJJG6p2H+Su/HQjgQoQq/+PyWQ
	 C+TwQRbAUSz0ceUI0T5Z4fhSzU3Ds4jAVwLvoy68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/232] kunit: qemu_configs: sparc: use Zilog console
Date: Tue,  8 Jul 2025 18:21:34 +0200
Message-ID: <20250708162244.011240720@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit e275f44e0a187b9d76830847976072f1c17b4b7b ]

The driver for the 8250 console is not used, as no port is found.
Instead the prom0 bootconsole is used the whole time.
The prom driver translates '\n' to '\r\n' before handing of the message
off to the firmware. The firmware performs the same translation again.
In the final output produced by QEMU each line ends with '\r\r\n'.
This breaks the kunit parser, which can only handle '\r\n' and '\n'.

Use the Zilog console instead. It works correctly, is the one documented
by the QEMU manual and also saves a bit of codesize:
Before=4051011, After=4023326, chg -0.68%

Observed on QEMU 9.2.0.

Link: https://lore.kernel.org/r/20250214-kunit-qemu-sparc-console-v1-1-ba1dfdf8f0b1@linutronix.de
Fixes: 87c9c1631788 ("kunit: tool: add support for QEMU")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Stable-dep-of: 1d31d536871f ("kunit: qemu_configs: Disable faulting tests on 32-bit SPARC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/qemu_configs/sparc.py | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/kunit/qemu_configs/sparc.py b/tools/testing/kunit/qemu_configs/sparc.py
index e975c4331a7c2..256d9573b4464 100644
--- a/tools/testing/kunit/qemu_configs/sparc.py
+++ b/tools/testing/kunit/qemu_configs/sparc.py
@@ -2,8 +2,9 @@ from ..qemu_config import QemuArchParams
 
 QEMU_ARCH = QemuArchParams(linux_arch='sparc',
 			   kconfig='''
-CONFIG_SERIAL_8250=y
-CONFIG_SERIAL_8250_CONSOLE=y''',
+CONFIG_SERIAL_SUNZILOG=y
+CONFIG_SERIAL_SUNZILOG_CONSOLE=y
+''',
 			   qemu_arch='sparc',
 			   kernel_path='arch/sparc/boot/zImage',
 			   kernel_command_line='console=ttyS0 mem=256M',
-- 
2.39.5



