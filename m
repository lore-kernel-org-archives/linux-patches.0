Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050C340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301033; cv=none; b=hWlM5KgaIll37ty4e6a/rue3b4rWqzDY9RMZ1VAquLbqy/ehaNcDnO2U4qWmdd55FReBBFKNmtPa24QSgChEEFoHOgewMb1QKXlFs6Tzh8gg3wuHiwx0ZbplNlNpmobDZkq9Ed8hKS4qTziVdb5HHyuW0ZU9besSNF5WGx6qw8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301033; c=relaxed/simple;
	bh=qQVS1+SNYkHb2oV7rUK6aHfhX6IPuk23megtrKNAwwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWUMw4wS/hddYEL7ocmGIqGpmLoJhSMp5krL/tfGxo7zymnoxwztzyBiY8a+DCwoswirKCsZZg0Mv2YMuPoxB5sj4wbA4ehAPKCM2wGNIy3wO4TLGAmmHuuASAHlJTJQYiyXBIs012Z/z4aGBJg5I4btJ6xphgdbtvNlG1rjx+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=COSYyelX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="COSYyelX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE30C19423;
	Sat, 28 Feb 2026 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301033;
	bh=qQVS1+SNYkHb2oV7rUK6aHfhX6IPuk23megtrKNAwwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COSYyelXvJywobncAq+zyNrHyHliDves9zivL9CZ7OxaUu7fLT1q4HSkpyyPqVMeo
	 6h2tuCjtze3F65a3ZGXHnN8x4K3f+mhJUHPrzW6mV9W8zhcpqHTLNZGO4fn2vw/so3
	 Fn3GNOM+GcL90iTvW4ktLcARyWMTU7DqqcnAa54+N2UH+4hwRrLVE5JNMPBWWYrlUg
	 zbRgAFcBHW4PAKS8NsJR7eK+cqT/ddHaXF476+HeBuFsctTs5vsXhzedm2dlgUAXL8
	 qVYdSRYosNb4NukQQHbsUOiwPIRN1ZjxAa/K2BPNe6Tw2MsSxf51qKxaCK69V0PF0q
	 WOp8E7coIw6nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Wei Liu (Microsoft)" <wei.liu@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/752] hyper-v: Mark inner union in hv_kvp_exchg_msg_value as packed
Date: Sat, 28 Feb 2026 12:38:02 -0500
Message-ID: <20260228174750.1542406-171-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 1e5271393d777f6159d896943b4c44c4f3ecff52 ]

The unpacked union within a packed struct generates alignment warnings
on clang for 32-bit ARM:

./usr/include/linux/hyperv.h:361:2: error: field  within 'struct hv_kvp_exchg_msg_value'
  is less aligned than 'union hv_kvp_exchg_msg_value::(anonymous at ./usr/include/linux/hyperv.h:361:2)'
  and is usually due to 'struct hv_kvp_exchg_msg_value' being packed,
  which can lead to unaligned accesses [-Werror,-Wunaligned-access]
     361 |         union {
         |         ^

With the recent changes to compile-test the UAPI headers in more cases,
this warning in combination with CONFIG_WERROR breaks the build.

Fix the warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512140314.DzDxpIVn-lkp@intel.com/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-kbuild/20260110-uapi-test-disable-headers-arm-clang-unaligned-access-v1-1-b7b0fa541daa@kernel.org/
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/linux-kbuild/29b2e736-d462-45b7-a0a9-85f8d8a3de56@app.fastmail.com/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Wei Liu (Microsoft) <wei.liu@kernel.org>
Tested-by: Nicolas Schier <nsc@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260115-kbuild-alignment-vbox-v1-1-076aed1623ff@linutronix.de
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/hyperv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index aaa502a7bff46..1749b35ab2c21 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -362,7 +362,7 @@ struct hv_kvp_exchg_msg_value {
 		__u8 value[HV_KVP_EXCHANGE_MAX_VALUE_SIZE];
 		__u32 value_u32;
 		__u64 value_u64;
-	};
+	} __attribute__((packed));
 } __attribute__((packed));
 
 struct hv_kvp_msg_enumerate {
-- 
2.51.0

