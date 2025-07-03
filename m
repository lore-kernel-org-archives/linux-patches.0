Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC272E7BD6;
	Thu,  3 Jul 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555093; cv=none; b=ao+trequImaSL51pLBHYNZcABQLSW8tsypFkEIe4m8SkxrLjOJ2XXcGx+Sc753E/cylRoe+YMRe3CSEbIQZz5FtjUXZ24+T/jcW90WkXmNh7EcC8QX0MKngsQeiwGwX78avotft6MCx//k5k3l3k9Zvw0BuvIfjJiHFHcnNDL7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555093; c=relaxed/simple;
	bh=x27GByyevSoXJ9NGiBEoUhihJxA70X3rU/t4n4ch6xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mgl4eMZurzEumMn13mInefB27vVvL6M1VTOAbJgaGmo8eGXY7cMWs9+0EiDVcjxQgU0LjWCc1ji5mn4fc35Mrrgy2YX+lCsmRgMV4qTHUVeWvYfThpwFHI2QcI42xE3DS1WE7Uz1qU4ZzqBLLIc3+KHcZg+ufdpvyGUX+kp+TqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JT0X1Hc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JT0X1Hc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DB5C4CEE3;
	Thu,  3 Jul 2025 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555093;
	bh=x27GByyevSoXJ9NGiBEoUhihJxA70X3rU/t4n4ch6xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JT0X1Hc3ioZawkYA1zSUPz3F1tMCSM+kjFasR77SGHvAlCeTID9gjmohWGlt8wpNa
	 Dqx0oxhxyBm4TBr62D3Mebv57Eww4O9jwv5gNBDprV9VWvM0biR2bZOmBKzVd7H4+w
	 U7W2e8D1NwHtmNJ4U18pVCUZ0p/kXG1aqBbSQfec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yao Zi <ziyao@disroot.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.15 174/263] dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive
Date: Thu,  3 Jul 2025 16:41:34 +0200
Message-ID: <20250703144011.326209267@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,7 +45,7 @@ allOf:
                   - ns16550
                   - ns16550a
     then:
-      anyOf:
+      oneOf:
         - required: [ clock-frequency ]
         - required: [ clocks ]
 


