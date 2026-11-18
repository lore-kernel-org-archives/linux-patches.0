Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033329;
	b=XuOOHEwBfAiFva1QrPBEB5YWlqam4xcjD6VjWqsr2wsP/reUNFCIBG3w4cy1PRhpeOxm
	 K8d0fCx6TDJjp3+/D4jcUJDDQWlLX5ekmPIzyqiF4MMn3s+vUSZeJTAFeXW/KIGkngI8p
	 91jeq+Jr/C1SDXX5zfclZb/RNXgveH7zrpi7I9NiVKOOTcvaVuPnWaYw7/43PLLPbQXwi
	 qMx3NYhlUB0zYMgkyJR1aR1ZElxVPI7+P9qGIkyHuMPChMZDgb1Q9QSivCyTIGuqnbSZw
	 P4bMSi2y2oozsHF4VxbrhOEdnlazNVGl/N4Aj0BccIyjTWqF3AfsolB4iowvvFgJ75g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6j2azQrdV58fJRKnQ+JcGcn7hvRwOWmvcjB3FgdLamo=;
	b=LAiVJDkWTFgaZX6AS3X4aCUKy3BbcRt44TciNWnSusg30XiYiquMAbR7J1VhJQ7H9uXT
	 BlkrZHJD/d+FJjkL89O3KwBflzuqpEDuDDR7S4svALlnH4Whz1X9dd46GVU5H5DvTyNe6
	 CLEZVggTB5dNfSdO3lNlfOniGrzl/HCVtydhIaQIoHWHIihCMCoACizb91jG5fmSULPa/
	 P/pa4vlqIXoBH+F5tbPqAiZuiutuLoLc9VOfs830/eaPSO1sVpaT7J3rLp0x0Qu3y+YIH
	 56gF9YjYhvrWw1xhTATYIuWgaAwSYel7h7i3hspBRrDBlEV8wtSCibmodMvuskEANlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bAO/Bd9x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC2606A325;
	Wed, 18 Nov 2026 20:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAO/Bd9x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D431F000C5;
	Wed, 18 Nov 2026 20:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033329;
	bh=6j2azQrdV58fJRKnQ+JcGcn7hvRwOWmvcjB3FgdLamo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAO/Bd9xqn+W6cZABAIsM6QJPJTeKWZx/6EDUoV7wTzvorutyfvybfEK/+ARAvo0r
	 59bGYfPXD0eguLFF/RBubuFDNnsrNF48hKctN7BU7B+rhi/MqalU7l9V5BtNTFBXl9
	 z+k0xrgiZ6+4H5CEU6hO/yj7fL+2+sjuwPw/Es/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 1729/1756] PM: runtime: Only queue an idle check for RPM-linked suppliers (part 2)
Date: Wed, 18 Nov 2026 16:04:16 +0100
Message-ID: <20261118150118.404842902@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

commit bd56424ce808fb1f92a4dc5bdeedc45b85c5d6cd upstream.

Commit be5755f023e7 ("PM: runtime: Only queue an idle check for
RPM-linked suppliers") was incomplete. There are two other cases where
we perform idle checks on non-DL_FLAG_PM_RUNTIME suppliers -- in
pm_runtime_set_suspended(), and in cases where we failed to resume
suppliers.

Fixes: be5755f023e7 ("PM: runtime: Only queue an idle check for RPM-linked suppliers")
Fixes: 5244f5e2d801 ("PM: runtime: Defer suspending suppliers")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20261103141442.v2.1.If69ddc515c2e9fd4338441e87688b9d690d2ef36@changeid
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -331,6 +331,9 @@ static void __rpm_put_suppliers(struct d
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held()) {
+		if (!device_link_test(link, DL_FLAG_PM_RUNTIME))
+			continue;
+
 		pm_runtime_release_supplier(link);
 		if (try_to_suspend)
 			pm_request_idle(link->supplier);


