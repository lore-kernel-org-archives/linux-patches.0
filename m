Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83CB145B0F;
	Thu, 13 Jun 2024 11:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279192; cv=none; b=ofUli+qM2FcSdZZwI8nGw0yUg87tZhEiyol8lDV0eKAOWDMprSKmv2g8zaUnqVPce1p+Sc2E4IJ6mKR1KCP/g76O2l0C8YUiV+T1i4WkdzyRyiv2iTfbLjO3V+y8dwDUUBtd7Cr/Qmj8CPHy3dpr9d3lNdIj8aG5eWbSwOWMFaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279192; c=relaxed/simple;
	bh=OdzRSiR+hikr9Oy36herJzEOjMydkAdRk5GWHLB7CyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLI79hVgpnch0SrOfEgUyhWNyu4jpsf8qlynrcHTqhmLWsP7kQpXysBPatOO4i4m44mk1DYjYMGGs2orZjPGZJvV+fMZfF59VOVF2B8FHFDmJ2KRxKVOre4GDxu/lrZYMZMP0KPcttYZoZCzBGSHh+Fu65DpnUXl9XK/EY4DCjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7xKAZ1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7xKAZ1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B0DC2BBFC;
	Thu, 13 Jun 2024 11:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279192;
	bh=OdzRSiR+hikr9Oy36herJzEOjMydkAdRk5GWHLB7CyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7xKAZ1fG0sKxHkf2ld+RZXsd2iPpc93fT8e5HCVT8dNGKrBslNm06gpbAEEzZKyB
	 hMdqDK2BT0nM53B39Vxd5HsjGz6rRhVEPfg7MQ0lcCBO9oCLLoY0quiZzsXFykonFB
	 ycZKkgTnXNZWzUbrzr3YlHELyRVhjYo58HcMJacc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 4.19 206/213] kdb: Fix console handling when editing and tab-completing commands
Date: Thu, 13 Jun 2024 13:34:14 +0200
Message-ID: <20240613113235.929854389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Thompson <daniel.thompson@linaro.org>

commit db2f9c7dc29114f531df4a425d0867d01e1f1e28 upstream.

Currently, if the cursor position is not at the end of the command buffer
and the user uses the Tab-complete functions, then the console does not
leave the cursor in the correct position.

For example consider the following buffer with the cursor positioned
at the ^:

md kdb_pro 10
          ^

Pressing tab should result in:

md kdb_prompt_str 10
                 ^

However this does not happen. Instead the cursor is placed at the end
(after then 10) and further cursor movement redraws incorrectly. The
same problem exists when we double-Tab but in a different part of the
code.

Fix this by sending a carriage return and then redisplaying the text to
the left of the cursor.

Cc: stable@vger.kernel.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-3-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -380,6 +380,8 @@ poll_again:
 			kdb_printf("\n");
 			kdb_printf(kdb_prompt_str);
 			kdb_printf("%s", buffer);
+			if (cp != lastchar)
+				kdb_position_cursor(kdb_prompt_str, buffer, cp);
 		} else if (tab != 2 && count > 0) {
 			/* How many new characters do we want from tmpbuffer? */
 			len_tmp = strlen(p_tmp) - len;
@@ -393,6 +395,9 @@ poll_again:
 				kdb_printf("%s", cp);
 				cp += len_tmp;
 				lastchar += len_tmp;
+				if (cp != lastchar)
+					kdb_position_cursor(kdb_prompt_str,
+							    buffer, cp);
 			}
 		}
 		kdb_nextline = 1; /* reset output line number */


