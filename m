Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062316;
	b=bhogIqLei4upJEcoC7dI+E7ejuT6IunKWK1N/etV7PUK9EE2Z9Utq9a34fGbGxsOu26l
	 DuiLHb/QARtq9RMVQmOK+8mFTjChuZYS/dhBxSojlJmF5ooD4O3agQuEwUJsuZYghdD6p
	 ms4LIyJ0GzPUFUnD+L7qvYEWKHfR0u+Y+Up2CBDGFQs9YwWbaVZch8njSqJDr49CNAk4Y
	 mdq/bTShcd9MA1GA79KaMel9+7xThn4h3A93QnNmgb5JHZSmzz5zK7dBI1Fs8gngMcngy
	 FE6TFAdc8f6SyL93Ja+FkTS6FmN+FSSX8EZ+1GAloBaMUQzVFKx9aYq8Hw01ZOVRYHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1r8wmYNiYkJ6x1eTK0lpvO6wXv7mcwSLDwYv1l4hhv4=;
	b=Zc2jhgr4yZQDcM1RYBck9wu9d/B6BzFcwHGvNLhaz6jk6D/yskqU4B+APgV7y3FNwkDj
	 WXM25HcaOjkqcMeAbwCCoDzloKTba+/iiQtNYHOZrCBeyncBk3NL20FGQeBjUvqm6oAju
	 4tVBrrl0uv/cFziWk+B3jy1KqAUXnL+JBhJ0ZtK28wyg0MWQpFZ/oYJDo7Psap+Y+m7ho
	 pf69kazb2uBvuJcbFlhf30HEEoB57NROhcnodgBgYYVfPriIho+U3OFOOTZH7ebpxR8Vy
	 RovFctCObpDgeYT+gynEhGmPTD6NHQyU6ym2Wc5xGTkgO6iN2GlqxsXELDidzgGUoPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="I6CQ/ZP5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13CA606A643;
	Sat,  7 Nov 2026 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6CQ/ZP5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E991F0089F;
	Sat,  7 Nov 2026 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062315;
	bh=1r8wmYNiYkJ6x1eTK0lpvO6wXv7mcwSLDwYv1l4hhv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6CQ/ZP5YzI+0W4/8WyoLTagpaWFC3fiUPzD4gPg8IwVrSKs6qnfe/Le7p2nbz827
	 6YvkSNPVYgcHSzuvp+BGfPRr17U7aqzcT1Hwo/TObbn5DSwklLrIEMXXYBKA6c9d24
	 xgYIysAkj/3BhtI320JMilQSVfK1JP+yqV1fhijQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1250/1536] platform/x86: hp-wmi: fix heap OOB read and memory corruption in hp_wmi_perform_query()
Date: Sat,  7 Nov 2026 08:54:26 -0500
Message-ID: <20261107135032.879167030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 6dea092b261f04d632411c2be52d13190f5f67b1 ]

hp_wmi_perform_query() evaluates an ACPI WMI method and expects a
struct bios_return header in the returned buffer. However, it only
checks that the ACPI object type is ACPI_TYPE_BUFFER without verifying
that obj->buffer.length is at least sizeof(*bios_return) (8 bytes).

If the firmware or ACPI method returns a buffer shorter than 8 bytes:

1. bios_return->return_code at offset 4 reads out of bounds from the
   allocated ACPI buffer slab.

2. If return_code evaluates to 0 and outsize is non-zero,
   (int)(obj->buffer.length - sizeof(*bios_return)) evaluates to a
   negative integer (e.g. -8 for a 0-length buffer). actual_outsize is
   set to this negative value and passed to memcpy(buffer, ...,
   actual_outsize), where the signed negative value is cast to
   size_t (e.g. 0xfffffffffffffff8), attempting to copy ~18 Exabytes
   and triggering an immediate kernel crash. Additionally,
   memset(buffer + actual_outsize, ...) performs an out-of-bounds
   write before buffer.

Fix this by ensuring obj->buffer.length is at least sizeof(*bios_return)
before accessing the return code, and compute actual_outsize safely
using min_t(u32, ...), which is sound specifically because the guard
above already rules out obj->buffer.length being smaller than
sizeof(*bios_return) by the time that subtraction runs.

Fixes: c3021ea1beee ("hp-wmi: allow setting input and output buffer sizes separately")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260826103012.240453-1-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index f6853fb746fc5..02227a4392907 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -386,8 +386,9 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 		goto out_free;
 	}
 
-	if (obj->type != ACPI_TYPE_BUFFER) {
-		pr_warn("query 0x%x returned an invalid object 0x%x\n", query, ret);
+	if (obj->type != ACPI_TYPE_BUFFER ||
+	    obj->buffer.length < sizeof(*bios_return)) {
+		pr_warn("query 0x%x returned wrong type or too small buffer\n", query);
 		ret = -EINVAL;
 		goto out_free;
 	}
@@ -406,7 +407,7 @@ static int hp_wmi_perform_query(int query, enum hp_wmi_command command,
 	if (!outsize)
 		goto out_free;
 
-	actual_outsize = min(outsize, (int)(obj->buffer.length - sizeof(*bios_return)));
+	actual_outsize = min_t(u32, outsize, obj->buffer.length - sizeof(*bios_return));
 	memcpy(buffer, obj->buffer.pointer + sizeof(*bios_return), actual_outsize);
 	memset(buffer + actual_outsize, 0, outsize - actual_outsize);
 
-- 
2.53.0



