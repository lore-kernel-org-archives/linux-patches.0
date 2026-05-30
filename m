Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A687231A21;
	Sat, 30 May 2026 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167082; cv=none; b=dw6vrVIuZYt450cwO5CXApX3MC1wC7Bg0mW8lKgpw1Go14R1JR6gzR8xKix3nAYPYhSg03MUPUFGUJHZuxTex4dlVEs87KVOVVQVJ5UieN0+IuAlBXOA7GatJiw7R3EIZQSI7Lz2B6fSifJvblwy7zhGlx2YzJxfSkEcIQZTQiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167082; c=relaxed/simple;
	bh=K6wUG/tPr/0AYcRmT8ErNjqyrE5CBztovys7IG3UQGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgAVr4ieZcbKFG9sF7zG47xgnHggF2sIEqSjqn+R62DgiwhNW3/xBiF4ovF/+CXdormvbcE5iMOrsx6abyjbZGlEtlp2oNla0qQRo/Rrc6tnuZcPCr8dQrW8dT0MzzhaslaH2p0GtLl2OR7Xhxr6Ph1mnF5HkIlNNztXml2CxDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjjoN7Y+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjjoN7Y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4B11F00893;
	Sat, 30 May 2026 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167081;
	bh=jPW+QjlGKakf4z9UFKDlSflsMhBb1esYc83tsb/OZ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjjoN7Y+fy84v6F7CehXRQygjDWLdCfLlZfq6U7avkOgCcSVEH2F1hD7y6Pp3pjoN
	 KXc857FI702yjSmCatVnrD4M9D23+/BC9giV9WCNzZK6+2rH5KuQa8P+YS6/Nng52E
	 u/5asr1+kh2INDvwbaOqpZz+VHubQcNlw5+XJz+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 558/589] batman-adv: tt: fix negative last_changeset_len
Date: Sat, 30 May 2026 18:07:19 +0200
Message-ID: <20260530160239.319720963@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit fc92cdfcb295cefa4344d71a527d61b638b7bfc4 upstream.

batadv_piv_tt::last_changeset_len len was declared as s16, but the field is
never intended to hold a negative value. When a value greater than 32767 is
assigned, it wraps to a negative signed integer.

In batadv_send_my_tt_response(), last_changeset_len is temporarily widened
to s32. The incorrectly negative s16 value propagates into the s32, causing
batadv_tt_prepare_tvlv_local_data() to allocate a full sized buffer but
populates only a small portion of it with the collected changeset. All
remaining bits are kept uninitialized.

Using an u16 avoids this type confusion and ensures that no (negative) sign
extension is performed in batadv_send_my_tt_response().

Cc: stable@kernel.org
Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1003,7 +1003,7 @@ struct batadv_priv_tt {
 	 * @last_changeset_len: length of last tt changeset this host has
 	 *  generated
 	 */
-	s16 last_changeset_len;
+	u16 last_changeset_len;
 
 	/**
 	 * @last_changeset_lock: lock protecting last_changeset &


