Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA132E54BF;
	Thu,  3 Jul 2025 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555850; cv=none; b=CVYTBLh0uY+tHCCgtA/8HmKB7dei08ThD0XLLBySKs6/nTJVDZKd0AvN16Q3PvB23Vl+0eIQ0iq0pwsFBsVpQUX4qoHQiLGaPUFIEyZiveA9zhdw67vHEedqTJeuSiFtIL0j5teNjL2jkZEOvEVhj9J5mXCnwWV0JCBl2MlYxjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555850; c=relaxed/simple;
	bh=WMlfZL7QrdFpHK6PiDuoF7zqVPYR8nVP28Y6B8aSFlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTVsLUveK6Homy1MxGt5OHC75Uz8yj2L/Iw2nTEZ7ZG0mueRJc1uoeTXk2wiQHRPuY8jfIUhVCMQ4o62AHbTyJz09tR+dqePsDVkKo31d8eaWMHoqZvrfXELO9QxHvgJKA6xaBLMFcAaiG1IGSlTOomzqtIbZoe0l8JTfDSbInk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkzGXuSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkzGXuSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F53C4CEE3;
	Thu,  3 Jul 2025 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555849;
	bh=WMlfZL7QrdFpHK6PiDuoF7zqVPYR8nVP28Y6B8aSFlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkzGXuSm/QNgXMj7Z7LbhLuN9xAATEsQKG8VLttgkiVTic2XETw44CrbZB8n1eBm6
	 NhEqqi4MZZHIpIUsqGVYLp4GaP49MNtfsXrzrBY8B/E9BUq/DHmIXGUQYTziuNr5Nl
	 UrBiLm7re5SCyNskQgZw3SzCKlF5GAFAb3uGEuXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Yao Zi <ziyao@disroot.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.6 097/139] dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive
Date: Thu,  3 Jul 2025 16:42:40 +0200
Message-ID: <20250703143944.962524670@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


