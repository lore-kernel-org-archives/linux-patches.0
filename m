Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E7E28689B;
	Tue, 26 Aug 2025 11:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208223; cv=none; b=P8SZA19JpHfxsio8Ell0QUZ0cW60wYbTx9ZOsjnk2+3TH0fA790Bal+YSonV6l21rJKU5Fa+Y11HpdD6OHPVo09viaphjQxLJvlCcataZPZVv2W4PnAbuT6zamSDpmkfw81BmLVeTNcZNltlRjuOTnGpWLQP/IsNHOu8754RI8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208223; c=relaxed/simple;
	bh=KcjFDcuTsjakhzA+0ZwmZNGZKbkipNPk9tGmZfKd9Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5WUsxTkTeEj0dNaKfAEPvPjC/xYyQ2tBfNOEW46vRHwJaGAWkv8z+PqERddz+7bOf+28XiR+MdAvAODxl2QMj6l3b+T5yYtfQ54mDe+EB6rP8hYEp/PXvi2l/CEp4SUz/MPiDCcP8gAC/ItUUYxRKrtFbKarGfrCr8cQ30DAtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d66IIuHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d66IIuHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224B8C4CEF1;
	Tue, 26 Aug 2025 11:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208223;
	bh=KcjFDcuTsjakhzA+0ZwmZNGZKbkipNPk9tGmZfKd9Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d66IIuHQ2JN1ijtQEhb5f2dhL3j2hOoFYq7R3/F2SdozSFICt1hwo/KE9zL9oJewu
	 rzclyLF8e/5bToLC828dnq0P3ENkLs0fGHTJJMzT06mslWIRBKGnehrWkZ9mYuRp52
	 anO232VJx0Sh6/Yyo6VCstkQlNwthA7jeh5U9aic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.12 028/322] tracing: fprobe-event: Sanitize wildcard for fprobe event name
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826110916.012073250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit ec879e1a0be8007aa232ffedcf6a6445dfc1a3d7 upstream.

Fprobe event accepts wildcards for the target functions, but unless user
specifies its event name, it makes an event with the wildcards.

  /sys/kernel/tracing # echo 'f mutex*' >> dynamic_events
  /sys/kernel/tracing # cat dynamic_events
  f:fprobes/mutex*__entry mutex*
  /sys/kernel/tracing # ls events/fprobes/
  enable         filter         mutex*__entry

To fix this, replace the wildcard ('*') with an underscore.

Link: https://lore.kernel.org/all/175535345114.282990.12294108192847938710.stgit@devnote2/

Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -2145,7 +2145,7 @@ static inline bool is_good_system_name(c
 static inline void sanitize_event_name(char *name)
 {
 	while (*name++ != '\0')
-		if (*name == ':' || *name == '.')
+		if (*name == ':' || *name == '.' || *name == '*')
 			*name = '_';
 }
 


