Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC07224B1F;
	Thu,  3 Jul 2025 15:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556280; cv=none; b=FucITASZrPG8kCZAqUEO5MbumoXrnRZWvLBRzWG4gUrDbhRP8iI6ZQqSNc05G+KePe8NQ881AISHyyDEPQFgfUGVhSq2TSmI8j6aOVNEqQrI6+J1wvPb/lnByY9vbruiYqIul7FnTGRdbyAm7QEObyesG73+et9c1tTsQxAVBkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556280; c=relaxed/simple;
	bh=7m92Zb7Ml09aI5JnSzne1gOS7/BajGdtOzQO8yuQhB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alDKco6VlzmQ+BgKfGxQnjHGYewfs9HY1/cbxidJj4NsnZhHvAV/cheOWAVnuw+8e0fPJhwNO3d+sd12Kw/Vj8uCgeYEp10rLsKw8xewrltL76nOj3oZYR5upmIQ1n9gRFFbNbbSdEvh+IVxs4/9GyyyK3AF+RzdqrFal97EM+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSaIFdCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSaIFdCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E419C4CEED;
	Thu,  3 Jul 2025 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556280;
	bh=7m92Zb7Ml09aI5JnSzne1gOS7/BajGdtOzQO8yuQhB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSaIFdCKdbvAkwJ9uRkgmBjpWZfdQLZp4x2SyRDXmO0hbSk8vltZa7jZPXFpj+9ky
	 HbLfDzh8O9s+cd7dPKayjG3BwG0XkzRlqTibqhmWWXPyGX7jPnPCmLP7UBNTxnaQKm
	 wadyuazWsneqgU/HlZDXTXwgUwkGjq2uMeSB1yN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yao Zi <ziyao@disroot.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.1 091/132] dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive
Date: Thu,  3 Jul 2025 16:43:00 +0200
Message-ID: <20250703143942.974352320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

commit 09812134071b3941fb81def30b61ed36d3a5dfb5 upstream.

The 8250 binding before converting to json-schema states,

  - clock-frequency : the input clock frequency for the UART
  	or
  - clocks phandle to refer to the clk used as per Documentation/devicetree

for clock-related properties, where "or" indicates these properties
shouldn't exist at the same time.

Additionally, the behavior of Linux's driver is strange when both clocks
and clock-frequency are specified: it ignores clocks and obtains the
frequency from clock-frequency, left the specified clocks unclaimed. It
may even be disabled, which is undesired most of the time.

But "anyOf" doesn't prevent these two properties from coexisting, as it
considers the object valid as long as there's at LEAST one match.

Let's switch to "oneOf" and disallows the other property if one exists,
precisely matching the original binding and avoiding future confusion on
the driver's behavior.

Fixes: e69f5dc623f9 ("dt-bindings: serial: Convert 8250 to json-schema")
Cc: stable <stable@kernel.org>
Signed-off-by: Yao Zi <ziyao@disroot.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250623093445.62327-1-ziyao@disroot.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/8250.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -44,7 +44,7 @@ allOf:
                   - ns16550
                   - ns16550a
     then:
-      anyOf:
+      oneOf:
         - required: [ clock-frequency ]
         - required: [ clocks ]
 


