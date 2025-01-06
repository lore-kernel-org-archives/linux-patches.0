Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD571514F6;
	Mon,  6 Jan 2025 15:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178274; cv=none; b=JSX7GFbQvaiZjRY57n+8ZqeQbgz+fEt6d3Zq/byRqn7E9ucc5shoqlvsfcHn/QvDutNBgpF3myntvfwDduTQ9XHz46akfwvIyghSKDBWv5zit5so7nY2r5DxM81A0kmpGm67D+oZmay8Bp4ZjOYbb33Ol0ViGWev2GKfrVBv55Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178274; c=relaxed/simple;
	bh=/Ik1wLDW3LRa929s/edNU3vypNr2S34NnEUJ6kU2h4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkf/oJrwNfbX8n+shVo23jmjmlZGde6UfgH/D6qkfUblh1xbV/JuWVtRWwKxpfVIxwQZ/pt/qakKcGSGgNDcDjS3PKes5KqVJzucVVbixWKIYkuKxk4BtfhbENYuG3qta0VpKX0w/AVEHyr53ZRsgQshFdg7CV81BcjnzesmdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVgSq3T/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVgSq3T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867D7C4CED2;
	Mon,  6 Jan 2025 15:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178273;
	bh=/Ik1wLDW3LRa929s/edNU3vypNr2S34NnEUJ6kU2h4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVgSq3T/NI9zKJCWj4UuKieXe3bA/fFAHBi+/aDi2BrjOV7NByFouJpRZF23GMdI7
	 nIWBmFWMv2uA9sizdx7AoDauLB2E2PmwcpN1s/V7/Duw4tNWGGl4DMrV7ZQB+Uqq++
	 chfzfZ1M+domK/0BEzLqTnxNwHoWGQXbYVQ+MaLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pau Espin Pedrol <pespin@espeweb.net>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/138] platform/x86: asus-nb-wmi: Ignore unknown event 0xCF
Date: Mon,  6 Jan 2025 16:16:28 +0100
Message-ID: <20250106151135.658074856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit e9fba20c29e27dc99e55e1c550573a114561bf8c ]

On the Asus X541UAK an unknown event 0xCF is emited when the charger
is plugged in. This is caused by the following AML code:

    If (ACPS ())
    {
        ACPF = One
        Local0 = 0x58
        If (ATKP)
        {
            ^^^^ATKD.IANE (0xCF)
        }
    }
    Else
    {
        ACPF = Zero
        Local0 = 0x57
    }

    Notify (AC0, 0x80) // Status Change
    If (ATKP)
    {
        ^^^^ATKD.IANE (Local0)
    }

    Sleep (0x64)
    PNOT ()
    Sleep (0x0A)
    NBAT (0x80)

Ignore the 0xCF event to silence the unknown event warning.

Reported-by: Pau Espin Pedrol <pespin@espeweb.net>
Closes: https://lore.kernel.org/platform-driver-x86/54d4860b-ec9c-4992-acf6-db3f90388293@espeweb.net
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241123224700.18530-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 49505939352a..224c1f1c271b 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -574,6 +574,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{ KE_IGNORE, 0xC6, },  /* Ambient Light Sensor notification */
+	{ KE_IGNORE, 0xCF, },	/* AC mode */
 	{ KE_KEY, 0xFA, { KEY_PROG2 } },           /* Lid flip action */
 	{ KE_KEY, 0xBD, { KEY_PROG2 } },           /* Lid flip action on ROG xflow laptops */
 	{ KE_END, 0},
-- 
2.39.5



