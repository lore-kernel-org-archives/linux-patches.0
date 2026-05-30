Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32768238D52;
	Sat, 30 May 2026 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167092; cv=none; b=qnij8f/yHrvZSpvvk9RBD8+Dtfk3V0EWyoJ9A222m2IVj0HR9UslBT26qVoBBoOZDgkSK1GCCLDRrlSS/QqgWnuNFf8H605qhJ3nqobIJyNJf6COBTMlINp3LQpkZMsCv9VpcjZLHgFC9wWvC09+qjWrGQVNpCK/fmgB4S7bD00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167092; c=relaxed/simple;
	bh=1NVRbFkCgIpFGg0jwgPXPiZV8wqw5NzK4npIpDp51So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwFVZj+4fzqP84Reo28UPBdMoLx4FgA5XSjqvYCD+/3qo0hBhQ6uHEWpy82+QiRC1EA0b+BhJt1qJFnC3B7S6DHpDS/NoHgm4syCEObtMXdOuNlxfg6QzKkqHAJ2EoX4oB55Fk7DRqTEsEKCwE6WSIiL/KqdXuol56GdAqsSj7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lu1EvHoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lu1EvHoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D371F00893;
	Sat, 30 May 2026 18:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167091;
	bh=iaWuW4TIYWWrvq2cp3cH6PwbXebkouv6ar6GkTdPpss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lu1EvHozUxlm4xWvCOLt+z5BjuB1GSMHqofQlkH5rNzyxKTCVqShrQtWgWuM4RzSq
	 ASl4EcPYz5XPFrohfDcQA7S+WHc9mOeomlAgil14oP9NKd7mT6n2gurRrgvpRttiJS
	 1W2+Wp80VLyDevB+ZE/OMDu+RakeeHZVaXzoKmXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 561/589] hwmon: (pmbus/adm1266) reject implausible blackbox record_count
Date: Sat, 30 May 2026 18:07:22 +0200
Message-ID: <20260530160239.390592198@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 4afca954622d672ea65ed961bed01cf91caa034e upstream.

adm1266_nvmem_read_blackbox() loops over a record_count that comes
straight from byte 3 of the BLACKBOX_INFO response.  The destination
buffer is data->dev_mem, sized for the nvmem cell's declared 2048
bytes (ADM1266_BLACKBOX_MAX_RECORDS * ADM1266_BLACKBOX_SIZE = 32 * 64).
A device that reports a record_count greater than 32 -- whether due
to firmware bugs, bus corruption, or a non-responsive slave returning
0xff -- would walk read_buff past the end of the dev_mem allocation
on the trailing iterations.

Cap record_count at ADM1266_BLACKBOX_MAX_RECORDS (introduced here)
before entering the loop and return -EIO on any larger value, so a
malformed BLACKBOX_INFO response cannot drive the loop out of bounds.

Fixes: 15609d189302 ("hwmon: (pmbus/adm1266) read blackbox")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260515-adm1266-fixes-v1-3-1c1ea1349cfe@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -46,6 +46,7 @@
 
 #define ADM1266_BLACKBOX_OFFSET		0
 #define ADM1266_BLACKBOX_SIZE		64
+#define ADM1266_BLACKBOX_MAX_RECORDS	32
 
 #define ADM1266_PMBUS_BLOCK_MAX		255
 
@@ -362,6 +363,8 @@ static int adm1266_nvmem_read_blackbox(s
 		return -EIO;
 
 	record_count = buf[3];
+	if (record_count > ADM1266_BLACKBOX_MAX_RECORDS)
+		return -EIO;
 
 	for (index = 0; index < record_count; index++) {
 		ret = adm1266_pmbus_block_xfer(data, ADM1266_READ_BLACKBOX, 1, &index, read_buff);


