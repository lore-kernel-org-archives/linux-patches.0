Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028469;
	b=M+ZcoHrTNLf61+537LshWWnZrfM2YM3YAjo8CJgjc6fNLi042KuAOJ4cHtpRcK45cQKh
	 V0T2fD4Y0a5faDb7bZlYfJxFo3sAPS+0aWEYLb+NfPRpd4K6B8Himzmm/Ewp9+BxYllfS
	 nJArZQl1krLQN0ej68py5Yf/EaKkSYwgcZngqHWXXFLsvlLCSteUWDO7KJaoCOxNzSliA
	 sYwTS/M0ZdgYQJetCbNZpOgmtc9bqMyFUoIQCa34f41e9hjRda984kK2mDuBFtlkJHbRW
	 0UDtbibqul1ZMaFtGn2SA/9VbkyBfn7EkaSSnlPRNM3JlglzX9E9fa9FQWVjfuSFn1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j6BCfzezr5X596b7rLI9NYZM79pECxcPWmuAybixAV0=;
	b=Of4sNiwI60uGfWVz4bySZc/Vnmg45qynJYrs0+ggOpe7GjzVNXLR0pH4+X4W3/hjZZaM
	 Yz6kvIcy0NZwTzgL9JXpwX8WV6pQDshvd7vsAH/HY/tloDRe5/Sa/yuaYMZ/qfDr2gYo3
	 atLjev+bSBgber4EWw4pTPV8EGfaBC8lwL1pixFmh7xthI/drJBhhRbF+cZIyPcflI6xj
	 zYC9rx5N4v3vezF9ubQA8eg8PLPiVAxIVCjk3C/BW/rT5tizv9HqWIKhQ80YMEtfLA4cJ
	 +oMiRPvkuFROJcjBQMbTNziJV17uihj9A6jF9DTJQV2W1foNY/WxC1+FOB5dvW73sNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSfkPk9Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C97D606A332;
	Wed, 18 Nov 2026 19:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSfkPk9Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30901F000CE;
	Wed, 18 Nov 2026 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028469;
	bh=j6BCfzezr5X596b7rLI9NYZM79pECxcPWmuAybixAV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSfkPk9Qdb5yZWeM6hNmNLYExea8Bqji2rZf/crG8CXB3U0aZC9DvkKfQ1G3VaOmm
	 jWk6JUKka5bxx6CKHhL2+ojWXN7zYoPkFTemJ8H8cxeybzGLmj3Z2Yy2IpzVNa9gz1
	 +nfMn2ersN/tr5+6B19NKmy3TAqP0NHPhqrnejSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 2137/2151] PM: runtime: Only queue an idle check for RPM-linked suppliers (part 2)
Date: Wed, 18 Nov 2026 16:04:32 +0100
Message-ID: <20261118150239.521147547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -343,6 +343,9 @@ static void __rpm_put_suppliers(struct d
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held()) {
+		if (!device_link_test(link, DL_FLAG_PM_RUNTIME))
+			continue;
+
 		pm_runtime_release_supplier(link);
 		if (try_to_suspend)
 			pm_request_idle(link->supplier);


