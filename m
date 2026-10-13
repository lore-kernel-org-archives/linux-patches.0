Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA57C4F3924;
	Tue, 13 Oct 2026 12:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892858; cv=none; b=gS4aycZCRF9Xq7ed8kb0Qgkv2k2F0cyGPzI7d31XbJOu0yrX5epgXL/+N1c5M+G+0nP3vau91168Z9uYmERhlPSPO5NvgIyS9k+yzOMKAHW2kqanVBzgocIzDIbdAzgN9TgG08KYBfWId5X5FOEq/KGKqAG7lBf//ug9Q52BifQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892858; c=relaxed/simple;
	bh=fj5TV7a70hopr6Ikd2KPKaf5eyVtp8SshyoKawuYHfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0HCLFRdtwFcYDfVV4u0YSGLJWFjgqmTmndn+v95MO8hhNuaAFuw1uINWbOV+QP39uR5OOsQqmDBJn3LxsL7/Sh0FXoD5cibJcV87eKX+TeGXpXx5FXku9XS7SGATRn9mCrspR1ehbQ+fe2a70wD7HqAnu25bEQpUL9bxpFZxUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy9TNrgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy9TNrgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7F31F00893;
	Tue, 13 Oct 2026 12:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892856;
	bh=FYNKDX1tR2ZkGOzdfa0cisM9ljJEyNpIJQBo8u4M3ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uy9TNrgOUwIPzVOlHJFyoHgjkB7UK002RK2a47XiUVPYeHUSG7iEUaTIHtDqCtgXY
	 UyNMuXiidQS018qncG1C/Z1KjDXW9jQMI7EywYXGwLEHPPtTVeVvG6sc8y8H9Ypdiw
	 ccdPdLQq03NfT/4i58a95yLd5XdlV8YhT5Tc6pDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ondrej=20Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 032/621] cipso: adjust cached option offsets when removing CIPSO
Date: Tue, 13 Oct 2026 13:30:27 +0200
Message-ID: <20261013112921.627424879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2287,6 +2287,14 @@ int cipso_v4_skbuff_delattr(struct sk_bu
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


