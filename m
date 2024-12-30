Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0A52AE68;
	Mon, 30 Dec 2024 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573818; cv=none; b=udRSVGahLxW9ZrOvzjZZr7DdUuzRJXwH47rJ0PhBM/9HP365/EsgpM1peIFbHAwLrRZRJ+BHa1aOQlettwQXpN1ArvsroOSG0g2B/8+K5EpH7uGGNGpjnAW2qZk9SawsVB03BQBrvqiu8K7+SICJn5QG1ozjf4+sCa8KPdyTN1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573818; c=relaxed/simple;
	bh=W848kwnVDSI+Q26jC8RtO+D1azuhW6QqPnB3ANwMUL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QW1FMHR4tUsFZM4UAUqXrDJGesDZrUFuVo/SfGtrqOexPqC+v2yZlUoIXkLZVuOVysk2GO/JFBJS7sP61dsQK+wFEGjir3KxO66LWcXOgWr2UhfZ4FEwbqsFv7HOVmUPo7td8mpuihRctNDKaSA9MkhViVb+MqXJu9ko4EmUcJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaIUZWmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaIUZWmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07F4C4CED0;
	Mon, 30 Dec 2024 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573818;
	bh=W848kwnVDSI+Q26jC8RtO+D1azuhW6QqPnB3ANwMUL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaIUZWmYyRouSmPb+dKfpmoy5vv/Nukt+acsVabv4uLb+h41AGAN10Vv5f2v8Rt4N
	 NSIC9KLRcRBsSogizNTTLc+eHx7FCch7ApVwOQmO5jFIrT3FKadw9Q9GFVWiXKzX71
	 4NMll3ACqZZJHCjtP0sHH3GTcAXta/SQUDRDu6ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pau Espin Pedrol <pespin@espeweb.net>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 43/86] platform/x86: asus-nb-wmi: Ignore unknown event 0xCF
Date: Mon, 30 Dec 2024 16:42:51 +0100
Message-ID: <20241230154213.349722330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af3da303e2b1..cba515ce3444 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -590,6 +590,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{ KE_IGNORE, 0xC6, },  /* Ambient Light Sensor notification */
+	{ KE_IGNORE, 0xCF, },	/* AC mode */
 	{ KE_KEY, 0xFA, { KEY_PROG2 } },           /* Lid flip action */
 	{ KE_KEY, 0xBD, { KEY_PROG2 } },           /* Lid flip action on ROG xflow laptops */
 	{ KE_END, 0},
-- 
2.39.5



