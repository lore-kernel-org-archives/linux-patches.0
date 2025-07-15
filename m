Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B822DEA96;
	Tue, 15 Jul 2025 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587558; cv=none; b=itBEI0JNXudhGbUmHqEmhu3XiCTOOy8CFcwyAhSTLqPrO69rNB4bE8rE08UDXb7oqSop1DYDrezvabskx+7B/IP5DxjNRrIH5b3v33KAeG2ibI913ZnGk1grbjCWr0zYCeTJ36ujWWMYqCwzc9dTETtqYl83jepJ6l7UeComHgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587558; c=relaxed/simple;
	bh=GiZR5QEtZVNKpg+DIST9duUhCk9n83b5NqCnHna6JhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxXULSHudLDKddtHhHWvH7OF3SEe3zDZZ2RFRmkx447vfFcHOUBOVm4S8Gn0HxVWTFUCzAEAiMgM27ggtChCJiH3lPWpMRP5gvzPZraWIaz/QssVEYCcb21961xVBeB3zb2DXFadi8YdmwWOD8NCfcyFK85sS+7gT17jWGjS1iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9phNROP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9phNROP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69789C4CEE3;
	Tue, 15 Jul 2025 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587558;
	bh=GiZR5QEtZVNKpg+DIST9duUhCk9n83b5NqCnHna6JhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9phNROPqbxaNRzQshObBPnnTUT6whQezYbFP0d2JK57t1hYwQ4cKEfR30krf7nfJ
	 x9ItYEqO/GvFft0pTKTSfYOGgatIPr5F8DtPuRwV5AJ1vPbuhxQR42NmBSddmQP5sq
	 +sC3LHeNrc4tYVC8B88Fi2ZpUhbGK8pkHQPaAZL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yao Zi <ziyao@disroot.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 5.10 056/208] dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive
Date: Tue, 15 Jul 2025 15:12:45 +0200
Message-ID: <20250715130813.195522472@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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
@@ -39,7 +39,7 @@ allOf:
                   - ns16550
                   - ns16550a
     then:
-      anyOf:
+      oneOf:
         - required: [ clock-frequency ]
         - required: [ clocks ]
 


