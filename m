Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425631A6803;
	Tue, 16 Jun 2026 17:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630537; cv=none; b=tVCLCalFcSTTQsJGOsInKkwydtcuAfyo/zHH6TCOz77A38XZCngRyyrwNctiWAKz3cJxGDEvIv11I5M5tigbJOg9Ofxud71ltukK6/ZhUDOBpjv16wbhfuvWJ7eS3vH9f/q7D1lOy72yzM2okQAJ4ekzbt5xz83MaetoQ+fSz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630537; c=relaxed/simple;
	bh=kRgu9an0fPD5AlCsYK3Yky+pe5hhnl1ZxlUZOf4cy5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqL+cZLj1Ye/JJqLOcnZQHlmeNFva7LCFl7kJe9E4jY+SFgHE5wpSqndiGseCUBv3WttYa8xqRAIJSu6a6Jpat2LiCQLRoGnOhlAr5ptKBYmZ73yUJwX/DyqefaDLKqcS8OpQgtdKa3P1gCCHO6xjaETeLh7g5UNTk2Vh6Eikkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoJPldY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoJPldY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CA01F000E9;
	Tue, 16 Jun 2026 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630536;
	bh=jSMAB7jMGqM3z7A61bgtmhmQEtu+Td0HX86O8POEEP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoJPldY9Z/DJZUS+JlNXpuPPuC0i9srUZMxfkSBJZfAx43kkAWr1WXYazBiiN6AzF
	 OmLMqmF4mtChh/PnSM+6ElFBtRqklA+ylCUPKXuAbmHSvjt7QmuHDVYOPoMaEooMEs
	 qOr2oR1AP9gyv9BNjuVG2x80ylPwjQFS6WFy6ITM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/522] selftests: forwarding: lib: Add helpers for checksum handling
Date: Tue, 16 Jun 2026 20:23:15 +0530
Message-ID: <20260616145128.017265167@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

commit 952e0ee38c7215c45192d8c899acd1830873f28b upstream.

In order to generate IGMPv3 and MLDv2 packets on the fly, we will need
helpers to calculate the packet checksum.

The approach presented in this patch revolves around payload templates
for mausezahn. These are mausezahn-like payload strings (01:23:45:...)
with possibly one 2-byte sequence replaced with the word PAYLOAD. The
main function is payload_template_calc_checksum(), which calculates
RFC 1071 checksum of the message. There are further helpers to then
convert the checksum to the payload format, and to expand it.

For IPv6, MLDv2 message checksum is computed using a pseudoheader that
differs from the header used in the payload itself. The fact that the
two messages are different means that the checksum needs to be
returned as a separate quantity, instead of being expanded in-place in
the payload itself. Furthermore, the pseudoheader includes a length of
the message. Much like the checksum, this needs to be expanded in
mausezahn format. And likewise for number of addresses for (S,G)
entries. Thus we have several places where a computed quantity needs
to be presented in the payload format. Add a helper u16_to_bytes(),
which will be used in all these cases.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 02cb2e6bacbb ("selftests: forwarding: vxlan_bridge_1d: fix test failure with br_netfilter enabled")
[bwh: Backported to 6,1: adjust context]
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 06027772cf79af..48d913341af267 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1701,3 +1701,59 @@ hw_stats_monitor_test()
 
 	log_test "${type}_stats notifications"
 }
+
+u16_to_bytes()
+{
+	local u16=$1; shift
+
+	printf "%04x" $u16 | sed 's/^/000/;s/^.*\(..\)\(..\)$/\1:\2/'
+}
+
+# Given a mausezahn-formatted payload (colon-separated bytes given as %02x),
+# possibly with a keyword CHECKSUM stashed where a 16-bit checksum should be,
+# calculate checksum as per RFC 1071, assuming the CHECKSUM field (if any)
+# stands for 00:00.
+payload_template_calc_checksum()
+{
+	local payload=$1; shift
+
+	(
+	    # Set input radix.
+	    echo "16i"
+	    # Push zero for the initial checksum.
+	    echo 0
+
+	    # Pad the payload with a terminating 00: in case we get an odd
+	    # number of bytes.
+	    echo "${payload%:}:00:" |
+		sed 's/CHECKSUM/00:00/g' |
+		tr '[:lower:]' '[:upper:]' |
+		# Add the word to the checksum.
+		sed 's/\(..\):\(..\):/\1\2+\n/g' |
+		# Strip the extra odd byte we pushed if left unconverted.
+		sed 's/\(..\):$//'
+
+	    echo "10000 ~ +"	# Calculate and add carry.
+	    echo "FFFF r - p"	# Bit-flip and print.
+	) |
+	    dc |
+	    tr '[:upper:]' '[:lower:]'
+}
+
+payload_template_expand_checksum()
+{
+	local payload=$1; shift
+	local checksum=$1; shift
+
+	local ckbytes=$(u16_to_bytes $checksum)
+
+	echo "$payload" | sed "s/CHECKSUM/$ckbytes/g"
+}
+
+payload_template_nbytes()
+{
+	local payload=$1; shift
+
+	payload_template_expand_checksum "${payload%:}" 0 |
+		sed 's/:/\n/g' | wc -l
+}
-- 
2.53.0



