Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042824;
	b=xQEWZTSDotlPQmHtin/Tgof5n2VHNvwLlNYQ5W6I96pMsrgnjcEqrg0kwm2tHtStQhH9
	 IsHC6g8XbW+X/dsylmLrbWo8DQ+sKdYROgYh75OvUEgTxK0QA1oMrmgJiscRiOcohdDwe
	 UAolz9r52KLNb7asPDmg/wnRkcFJjN/vdjwzJ4w27nncgGib3JZXZ7UPo+RS4Axjbb0VY
	 JH35GkSVBx96jT0lnSKnhD4f33Pf2xION70m9+8D4ou5og68XgMNGLbXchskke0U1a+yX
	 ToJAZDcqUPou98sGf24xHJVAMx+UMAoJz95uL8NgQX+idDtv6PBJdDiIBUmnwAT/94A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hwJGXaPaUiCZfnMJbc7fxqcfYNwJWaiIkxIvnMyyUYE=;
	b=Duncb1t1YFFtjKIA7hx/v/tiXK7PzZZfEYVcue4vbqDx/Wb05YFJszcMi/aUthvB1bbL
	 hlMnzCZxv2Bm0oz8liM/HCWVYY7sI+uFEnaRIPxTwB3x9R+UrXnPMwO1SkVnQeDvAHqpq
	 CeO+HHxHUV2oEMCc9KK4++FHG2mFY0t1qPdfAcki6+Y1GJgzbDtn/dmnkC5D5W570Z4vq
	 ErijjCvJvMaurABVbP8c4w9C7k96irtX6QVB3IumpLvPreo3gryVa0woE7QkFkK3oilA0
	 kkxDDOciA/+kCf/eoSrxnzeb5JQRn+nyNiDyjqYu0L4sRBaDyCtqISFj9CkbDskmehw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkl+EOZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACA2606A31C;
	Wed, 18 Nov 2026 23:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tkl+EOZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F641F000C4;
	Wed, 18 Nov 2026 23:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042824;
	bh=hwJGXaPaUiCZfnMJbc7fxqcfYNwJWaiIkxIvnMyyUYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tkl+EOZLYLojjOrKzG2Z90oWUjvmFAAF3l1r0lQyMCBLOLPXtf4K3xX+NAT1zFhnI
	 A8ufQS4kfJ6sbI/wV+U7TL0uSeN0wq4BAyiQx1EMqltdqpZA4HfZA5CmCmUYhQXrIX
	 UW2fJhVfwcCVg2MWjHeIXptVYYUjsNT3rh8T++5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.6 3308/3318] apparmor: avoid potential double free when remapping DFA tables
Date: Wed, 18 Nov 2026 16:05:30 +0100
Message-ID: <20261118150458.830909055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,7 +393,6 @@ struct aa_dfa *aa_dfa_unpack(void *blob,
 		/* check for duplicate table entry */
 		if (dfa->tables[table->td_id])
 			goto fail;
-		dfa->tables[table->td_id] = table;
 		data += table_size(table->td_lolen, table->td_flags);
 		size -= table_size(table->td_lolen, table->td_flags);
 
@@ -410,9 +409,9 @@ struct aa_dfa *aa_dfa_unpack(void *blob,
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


