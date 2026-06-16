Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51973C276B;
	Tue, 16 Jun 2026 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631941; cv=none; b=NguKtEJLX37MiaAuEIyYU87yNAiyiaZdh3zBlwvvLGJwgx3piQR2iJxDVzxKvVnX0p9t7MaF8JF6WXCdHb5bRiR7x6Zk27L4pqUSa8xLjtR08Re0Y7QFFVcFNGi4k7C8TuvgXwKmp6qOQDCIXGzRwxydGHvLg4PEy309kal+A7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631941; c=relaxed/simple;
	bh=wv3MsulsJIUJNzbbQ6CXKlp/RCF6KBJa2ErDBZR1HHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPNfxmzJUnIG0+rzgn8e9FX27E/Udwe9MHHw/kS203ZzGrBKrgzLEoVVh59+9YU4hvd0vm7INOZUHTMVoS1qM2ljVAUOUIrVuGYkP2YH+tDlpShNgLKiBzAtfiAiwc/kPvq6ZAsibX0ifnPYWY96kzRK8iRMAO2Osdmv4aIbngE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QE/6wOZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QE/6wOZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9579C1F000E9;
	Tue, 16 Jun 2026 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631940;
	bh=h9xQR1C0DSGiafT7WvRqjs4vs3cCkQVI9FrPyzXMMqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QE/6wOZ4Gy4Wy6K2/x1dWYiQYW9i/IA/iUMunu5qYDAguxCyEeia/JYbOF2jC3BZk
	 3FjUtKPU6Hyc4/hGvWgfQvVR6rTOQtu9zSCrrwVBgXuM3BcPU3T7t4izDd5WXUzuiE
	 ns5FB0fHaNpLzNaAnYd1oHw6n3CYTjEvxLIOkg7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 317/522] thunderbolt: Clamp XDomain response data copy to allocation size
Date: Tue, 16 Jun 2026 20:27:44 +0530
Message-ID: <20260616145140.686934705@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 322e93448d908434ae5545660fcbe8f5a7a8e141 upstream.

tb_xdp_properties_request() derives the per-packet copy length from
the response header without checking that it fits in the previously
allocated data buffer.  A malicious peer can set its length field
larger than the declared data_length, causing memcpy to write past
the kcalloc allocation.

Clamp the per-packet copy length so that the cumulative offset
never exceeds data_len.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -393,6 +393,8 @@ static int tb_xdp_properties_request(str
 			}
 		}
 
+		if (req.offset + len > data_len)
+			len = data_len - req.offset;
 		memcpy(data + req.offset, res->data, len * 4);
 		req.offset += len;
 	} while (!data_len || req.offset < data_len);


