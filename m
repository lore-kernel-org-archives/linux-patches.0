Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A97827FD63;
	Tue, 27 May 2025 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368646; cv=none; b=er9lqo9bRCwafayyh8h6JJQbap+5QwdoOXv40zOmK34OTpRka+yh2f4VjCI9/vhO7FF2Q/dn3wqpm0+tUk0L57fFqvcdy6AAhIL+Il1l7Qs9KgEFFImxFpnNmP4j/W3Zgc3QnI390DZxuYPsOa4rGI4U75pwFo97Lfugw/24BkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368646; c=relaxed/simple;
	bh=p7Rl5pRXIH799Xo1LoYJNT5+Lk6ZJ4qH+3JV7vioMAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmA9UeaVSHhniln6UlxUcbwe5t0P5RCGPQkQUYrjyfHXscxYjkLVZ/6eliT7vc3rgxoVULLUR8I71kYx2KAsT8XLBozuLqmzcZd6MTEUE+28nLrOlZ9oiqBKth3Z8x5kEkT2l1wRDEg5INL7+JJ6DkJ/Y8Zf5svSVuNZmSaITnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcTCdath; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcTCdath"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113C6C4CEE9;
	Tue, 27 May 2025 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368646;
	bh=p7Rl5pRXIH799Xo1LoYJNT5+Lk6ZJ4qH+3JV7vioMAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcTCdath7oBCHD6Ao1wp8iTMqVFQiH29zc1PWJ7/6z2uSKwiVFHhJlNNdUlO1w8/0
	 bErJgJsOWXUID0QqkrwYEqA0AOrjqh0CXArRfndwXXkF5ssLEFUyvdsyYXLP5c4Ruv
	 FFWLacu0tMQcD1BQ9d73RqNIW7Keyg5fTckzNSGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	zhang ning <zhangn1985@outlook.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.14 743/783] thermal: intel: x86_pkg_temp_thermal: Fix bogus trip temperature
Date: Tue, 27 May 2025 18:29:00 +0200
Message-ID: <20250527162543.383249706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit cf948c8e274e8b406e846cdf6cc48fe47f98cf57 upstream.

The tj_max value obtained from the Intel TCC library are in Celsius,
whereas the thermal subsystem operates in milli-Celsius.

This discrepancy leads to incorrect trip temperature calculations.

Fix bogus trip temperature by converting tj_max to milli-Celsius Unit.

Fixes: 8ef0ca4a177d ("Merge back other thermal control material for 6.3.")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reported-by: zhang ning <zhangn1985@outlook.com>
Closes: https://lore.kernel.org/all/TY2PR01MB3786EF0FE24353026293F5ACCD97A@TY2PR01MB3786.jpnprd01.prod.outlook.com/
Tested-by: zhang ning <zhangn1985@outlook.com>
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Link: https://patch.msgid.link/20250519070901.1031233-1-rui.zhang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/x86_pkg_temp_thermal.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -329,6 +329,7 @@ static int pkg_temp_thermal_device_add(u
 	tj_max = intel_tcc_get_tjmax(cpu);
 	if (tj_max < 0)
 		return tj_max;
+	tj_max *= 1000;
 
 	zonedev = kzalloc(sizeof(*zonedev), GFP_KERNEL);
 	if (!zonedev)


