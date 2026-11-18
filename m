Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033403;
	b=tvDJRMmRdTSRvSI8IBGgGYtIDberXUgmktHCUpLcbDwZYt6ko/zG7L9R00LTE1Lb64pT
	 TQ+0wZL0LlIPRVMfvNDWnm0Y5NJpYaWMWzqopqg2PHEQUm8/ACtu7I8x34fNY7wsS10nm
	 PnLQ9JehV5u3gOuW41W0NaNUjP+dLAkrnELCij7ms64aWi0OkxH5znSLISZ9BEiR2FmKr
	 9gYAD44F2wWlHNuuQ3oxInrAR8LTlSW3Os/vLYm8BxUgnMMOlyU2Rsg0keYLhbhpIwQ3w
	 aFM4w4P5BuFaAxL58gjUsP7elcbxypyMlFYXOG3rfsHuE0Kdb9iOCQX87+JRGc/w8Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HeOkXVcczdbQijMnw3Ey4rLMDR1e66prKVEyhfHWB2I=;
	b=hBENT3A+BEFkUhzIqjqsljT1CiiMrVAQG5/jir0WIKbfkKCtSslkeDOGDVR7gX4Wd31Y
	 l1pGjNAuWl8nGHLc5yCzRJ18QMJhO7TZW2C3SCiPxsYcfPrqmTWZmnQId/7OalNSOTl/W
	 VRQwghBwRPWWIlHCdCrxiC99vOaXiGMJnvDNY+x4Tl9TxK9qyAFsPkDi3Fo3kWYhBPJzz
	 U5gSkYSTTWeP5FngB2D5Aa+YsftVpHRYYbpkaiuI68XEzto2MZwBD7Tpy+aDYaChLUvgi
	 Y4w7GKmVKzi6iUyrTpnYHPY4S9hCfBU/wsZzRw4dSTL0SQ688QToMSc8cJkcJKsQp4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFskAFWs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84905606A335;
	Wed, 18 Nov 2026 20:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFskAFWs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56EF1F000C4;
	Wed, 18 Nov 2026 20:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033403;
	bh=HeOkXVcczdbQijMnw3Ey4rLMDR1e66prKVEyhfHWB2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFskAFWsloqlDLMA6X9CCTMy9jMg+Yi91OisKEG0C77NnK3seSNADKSY0RbF1aSK3
	 zI2T+UB93qt/eEmwEnK3DhAoJDaHToYGDws7tUeV8hZ9+Lg0zxMoS1YOFO1kIKxaGU
	 WN+7e3l9Mb1UHbSuQWRSvODG2ZNTlf1uXZWxPfmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 1756/1756] apparmor: avoid potential double free when remapping DFA tables
Date: Wed, 18 Nov 2026 16:04:43 +0100
Message-ID: <20261118150119.431173036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit 7ccd884a5e5386f4c7d98625113f4924f70286b4 upstream.

When unpacking a DFA, aa_dfa_unpack() stores a table in dfa->tables
before attempting to remap a 16-bit table to 32-bit.

However, remap_data16_to_data32() frees the original table when
allocation of the new table fails. This leaves the corresponding
dfa->tables entry pointing to freed memory. If the unpacking then
fails, dfa_free() attempts to free the same table again.

Only publish the table to dfa->tables after any required remapping
has completed successfully, so that dfa->tables never contains a
pointer to a table that has already been freed.

Fixes: 9208c05f9fdf ("apparmor: add support for 2^24 states to the dfa state machine.")
Cc: stable@vger.kernel.org
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/match.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -401,7 +401,6 @@ struct aa_dfa *aa_dfa_unpack(void *blob,
 		/* check for duplicate table entry */
 		if (dfa->tables[table->td_id])
 			goto fail;
-		dfa->tables[table->td_id] = table;
 		data += table_size(table->td_lolen, table->td_flags);
 		size -= table_size(table->td_lolen, table->td_flags);
 
@@ -418,9 +417,9 @@ struct aa_dfa *aa_dfa_unpack(void *blob,
 				if (!table)
 					goto fail;
 			}
-			dfa->tables[table->td_id] = table;
 			break;
 		}
+		dfa->tables[table->td_id] = table;
 		table = NULL;
 	}
 	error = verify_table_headers(dfa->tables, flags);


