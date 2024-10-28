Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED3F8837;
	Mon, 28 Oct 2024 06:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097911; cv=none; b=F0tELTS7KOrYcvqhFedMKu+/YuCCQDG/+Ucmn6y1fnjINiH0Rd8rRG1sYYIFgxeKApGGXZEf1zWWcO+hm1AGtZANT8CdFSNIh9r/Buf+racZK5f/y4rFCiQTio3JoL+f1OfudsKLb7JTMk12yPhWSvqxAlwabD3gsOBYPlbls4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097911; c=relaxed/simple;
	bh=csecOZndsbpvHnVSLiOVDotcFA2SwFg/KJLt9oxv8U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsGJCMS9K5x2j+/hS0nQLFfcJdC6Q4O2piajWFKlYHt2UQNlgi4Mqld8AYM33q5XJzmH6K+Nf/vF1K8bAziSbo0lS+n5JkoS+9c8HOhoeyQo8Hf+/E6Y9YQclqZAhx6iLDgKfHmsGKYM4giO/1Csat57POMy2tarfjryBjs8LyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCc1eJre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCc1eJre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2697AC4CEC3;
	Mon, 28 Oct 2024 06:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097911;
	bh=csecOZndsbpvHnVSLiOVDotcFA2SwFg/KJLt9oxv8U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCc1eJreKu6LpoRUTr/ntXTndArnsrkDBDsPGKRP7dLehULHeECMUdUFm2StrRiu5
	 59yFd/eBC9w/9HBbst1EEqR7ffTq8UWUNcG9eMUcG1Owd77Eh6Dq9U2hCD/e2wS8Jh
	 Rto9CtYdMwoAM+1NmScHorOMA8U0oYpdnRRZOsOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	siddharth.manthan@gmail.com,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 202/208] platform/x86: dell-wmi: Ignore suspend notifications
Date: Mon, 28 Oct 2024 07:26:22 +0100
Message-ID: <20241028062311.619094053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit a7990957fa53326fe9b47f0349373ed99bb69aaa upstream.

Some machines like the Dell G15 5155 emit WMI events when
suspending/resuming. Ignore those WMI events.

Tested-by: siddharth.manthan@gmail.com
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20241014220529.397390-1-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -264,6 +264,15 @@ static const struct key_entry dell_wmi_k
 	/*Speaker Mute*/
 	{ KE_KEY, 0x109, { KEY_MUTE} },
 
+	/* S2Idle screen off */
+	{ KE_IGNORE, 0x120, { KEY_RESERVED }},
+
+	/* Leaving S4 or S2Idle suspend */
+	{ KE_IGNORE, 0x130, { KEY_RESERVED }},
+
+	/* Entering S2Idle suspend */
+	{ KE_IGNORE, 0x140, { KEY_RESERVED }},
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 


