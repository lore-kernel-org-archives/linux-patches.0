Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09688268C61;
	Tue,  8 Apr 2025 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112059; cv=none; b=XA5/gkxjA5c3m6KoOSszVQxHIwjmHEY+oxhDOF82qPBqOCtCfLaNgM7p6+Vk7xR+b0IflXKfkfGWXTzR7WKD5+rEiG0SlDo1qWBV8Tst6F2SEmVkDrOOrvLumW5Q8MxYA8wbpSaGUw+Q5oMNnH1bWpYU+AnS4eP6AGSIiD9rS0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112059; c=relaxed/simple;
	bh=760VnTs7RmXJ2o1hFihLKrHWe8fqLjX3txtUjV97MFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8WyNUA4JL5dTlqxH180OrAcE+b2umXki6TDPtQ09RXIHAQE+q8a9ZI6E6pbNYfq8QrrVvFiCLwKuOXBWdtMClOl4xwZ7LboXuvxw8gBTIVHPBSEAllw41TTQtNNloNqdQbAZSeOSJqi8b0fJw/1v3lEYg+w0GFIYHujh9422qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSuBBHdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSuBBHdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F67CC4CEE5;
	Tue,  8 Apr 2025 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112058;
	bh=760VnTs7RmXJ2o1hFihLKrHWe8fqLjX3txtUjV97MFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSuBBHdQsqB0v/dZbkMuDr8YUXgDU6/Cv9HvmzGns+Wyuzo5aIjwGs9iXvGkMNyl8
	 ZzkgodJ+TZGGZy/BNpO+T0keilU2I2Q+mjSsiEy18C1iZUJ1IQ9akJlWfRFHpW0cYQ
	 1FTp1u1IIH7rXLnOvHvCfhGsj80kgyl71MJAiw5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH 6.14 660/731] rust: pci: require Send for Driver trait implementers
Date: Tue,  8 Apr 2025 12:49:17 +0200
Message-ID: <20250408104929.619656201@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 935e1d90bf6f14cd190b3a95f3cbf7e298123043 upstream.

The instance of Self, returned and created by Driver::probe() is
dropped in the bus' remove() callback.

Request implementers of the Driver trait to implement Send, since the
remove() callback is not guaranteed to run from the same thread as
probe().

Fixes: 1bd8b6b2c5d3 ("rust: pci: add basic PCI device / driver abstractions")
Cc: stable <stable@kernel.org>
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://lore.kernel.org/lkml/Z9rDxOJ2V2bPjj5i@google.com/
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Link: https://lore.kernel.org/r/20250319145350.69543-1-dakr@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/pci.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/pci.rs b/rust/kernel/pci.rs
index 0d09ae34a64d..22a32172b108 100644
--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -222,7 +222,7 @@ macro_rules! pci_device_table {
 ///```
 /// Drivers must implement this trait in order to get a PCI driver registered. Please refer to the
 /// `Adapter` documentation for an example.
-pub trait Driver {
+pub trait Driver: Send {
     /// The type holding information about each device id supported by the driver.
     ///
     /// TODO: Use associated_type_defaults once stabilized:
-- 
2.49.0



