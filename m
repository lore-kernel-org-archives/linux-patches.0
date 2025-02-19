Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBCA1C68A6;
	Wed, 19 Feb 2025 08:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954318; cv=none; b=KFJXRkhjehcRi9/YD1oWNY/rRPsu+UYGKNAI87wc+Owlg8h4YwZj0vViRtmSDYbCLvMxOYeKp1uEqOrY5D3wnSZCt3P9JRLFrvme/dzrBPWIvWc6oX/hbw4lIzPC7r5BBhE1v2ALd8VwCgk2iwQLm0eHgArHGRzujj9IKskjNQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954318; c=relaxed/simple;
	bh=9xp7R6NZsbtsqBoCtQG7PgrJjye9Mvr2NEnshoCgxmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcvvcFkz8QNhwL5jp48HnZNNiJLuDqyhG0BX9iJ3NxNaQEo3K9g2Te5B0SK1nhRMHDaQXS3a4bbAtQwGV6MDP8Zjms+TKnFwUWvU+VQJAFTRZpG/J48wfvZ0IuLhhKyrHbp/YxSHhqphnhhUKVbNYseJyxu9/4CbwhLe+6R3qcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdYYjJmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdYYjJmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AF8C4CED1;
	Wed, 19 Feb 2025 08:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954318;
	bh=9xp7R6NZsbtsqBoCtQG7PgrJjye9Mvr2NEnshoCgxmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdYYjJmpma/u3OetIVkoTE0UkUU0gy5Y0p9YbLfZp6PC0geQhmSVHwZ0d6KVvXkz4
	 X54fkl9AfpHfGlSCuSm9lO4G04xnA4A6Ws93cRTdLixeCRtqZUBFdW636u8y6byRmu
	 rbwg8iSEDimqbBjFsyte31esnUFXZm8UnNaWy4Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.13 166/274] serial: port: Always update ->iotype in __uart_read_properties()
Date: Wed, 19 Feb 2025 09:27:00 +0100
Message-ID: <20250219082616.090255790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit e8486bd50ecf63c9a1e25271f258a8d959f2672f upstream.

The documentation of the __uart_read_properties() states that
->iotype member is always altered after the function call, but
the code doesn't do that in the case when use_defaults == false
and the value of reg-io-width is unsupported. Make sure the code
follows the documentation.

Note, the current users of the uart_read_and_validate_port_properties()
will fail and the change doesn't affect their behaviour, neither
users of uart_read_port_properties() will be affected since the
alteration happens there even in the current code flow.

Fixes: e894b6005dce ("serial: port: Introduce a common helper to read properties")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250124161530.398361-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -228,11 +228,11 @@ static int __uart_read_properties(struct
 			port->iotype = device_is_big_endian(dev) ? UPIO_MEM32BE : UPIO_MEM32;
 			break;
 		default:
+			port->iotype = UPIO_UNKNOWN;
 			if (!use_defaults) {
 				dev_err(dev, "Unsupported reg-io-width (%u)\n", value);
 				return -EINVAL;
 			}
-			port->iotype = UPIO_UNKNOWN;
 			break;
 		}
 	}


