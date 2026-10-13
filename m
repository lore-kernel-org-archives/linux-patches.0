Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D93E2ADB;
	Tue, 13 Oct 2026 12:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895709; cv=none; b=TlEsyHOHWB7enNPcYoDEggnleSxYjJSGm+jYK4Ih+uQeEwbgoOdTZsRFnIuArpKJX1XaMlYlnuc6+VzLrpUk5kVeufXPiF1IZOpRJXPwIXnTBG9ipZGa6TFo8UbYM96v2Y+SoGIoYvS+2+7gZEmLHWJXPaRI/enb86CasFuioR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895709; c=relaxed/simple;
	bh=eYG5XhYzSiLDBtxzLdjLNSJ05NQH7x0oQ9Sg0M7+SiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DJsluXk7q+fwRJmq5DNUjddHmG8wjVZwAk7YQLJzgA8VLRQR3v+OXtl3WleP3qEW+ZCoAryDXlFi3rkDVm+sOtaJTZ37mMjMZz1gjzCMiDepVzqqrAoAXxJ9vI1VMe9WQ+e65knG0g50eNw3o69NUcYGb7G0c6ZW6U30uF16Vd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKwl+J5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKwl+J5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13721F000FF;
	Tue, 13 Oct 2026 12:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895708;
	bh=1W7Rgfa0roy0AJrS1bphGi+a+TX4GDunR13QkjyvyTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKwl+J5vLOn7ZQf0RYrXLvagY79AHK5hNucj+uQygSHKPK9yvBJ3VOP+AkmyulX6+
	 stSJU0HOCrD5ks7LeKp8Er0Kn55XLQBkmyOY7eFo804n35rWFAYYz/hjVObGWacXUs
	 kHhVelCrVCk1ZSuTcujOgizPRQgGWqURf2kDe040=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 364/497] cipso: adjust cached option offsets when removing CIPSO
Date: Tue, 13 Oct 2026 13:38:51 +0200
Message-ID: <20261013112916.543314677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 6d25ffca055a77787c21a36b66c253f76239411b upstream.

cipso_v4_skbuff_delattr() removes the CIPSO bytes but does not adjust
cached offsets for options that follow them.

For example, with a valid 10-byte CIPSO option followed by a seven-byte
RR option, parsing records rr at offset 30.  Removing CIPSO moves RR to
offset 20, while the cached offset remains 30.  Consumers such as
ip_forward_options() and __ip_options_echo() then access the wrong bytes;
the latter may interpret packet data as the option length and copy it into
fixed-size option storage.

Mirror cipso_v4_delopt() and subtract cipso_len from the srr, rr, ts and
router_alert offsets when they follow CIPSO.  cipso_len is the distance
the first memmove() shifts those options.  The later header move and
network-header reset relocate the bytes and their offset base together.

Fixes: 89aa3619d141 ("cipso: make cipso_v4_skbuff_delattr() fully remove the CIPSO options")
Cc: stable@vger.kernel.org
Reviewed-by: Ondrej Mosnáček <omosnacek@gmail.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20261006035108.3101440-1-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/cipso_ipv4.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -2288,6 +2288,14 @@ int cipso_v4_skbuff_delattr(struct sk_bu
 	       new_hdr_len - new_hdr_len_actual);
 
 	opt->optlen -= hdr_len_delta;
+	if (opt->srr > opt->cipso)
+		opt->srr -= cipso_len;
+	if (opt->rr > opt->cipso)
+		opt->rr -= cipso_len;
+	if (opt->ts > opt->cipso)
+		opt->ts -= cipso_len;
+	if (opt->router_alert > opt->cipso)
+		opt->router_alert -= cipso_len;
 	opt->cipso = 0;
 	opt->is_changed = 1;
 	if (hdr_len_delta != 0) {


