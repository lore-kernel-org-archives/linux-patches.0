Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD1E3CFF4A;
	Tue, 16 Jun 2026 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633237; cv=none; b=efXqUP3f8XWjpVr3PEoxxPRq08uUi3xcdMkD8U9NtHus1I1Rk0nbg38pLM8kQklxZI/62XAn/ma6YyLQDBRBB/PD5IU9rR4ZTfOM4tsSDSe+zS4yv8TcXgXJoiiLEbN9+inQALwS6AGjf5ETg4K+OOIEFLW62CvBOp0MEjavGLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633237; c=relaxed/simple;
	bh=k6YTPh7dyuC6ZPM13OUifyfJ3dqAKFq4820n2A3bkRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzLN+lDUsRt4iS9BZWbuJAz8Z26ofTyncyYWZ+WGNe3VB9XpB/v6lHyBoj+pMArrSNP5tgEh7uDTdWpXGZRswGWxF3vRuR2xrEbCq+Tf0BnhWW9RjY7QH/JGQcq0hvhmp4tBAQUMEQB1Y9L+P82KNiUkZ70/a6ttpwPUthK22OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A34mQa7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A34mQa7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF3F1F000E9;
	Tue, 16 Jun 2026 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633236;
	bh=L8pAxwbmdtp49BwogWeRqDSWho72f8VDOfmRaYHGKJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A34mQa7zenk8mI36+LQkpBRrEKkPkrl6xLQAFhHQFL/J+9SlXG/OPKCE+8DjLSXnL
	 A6CHE+n1jopFeS/VyNQYJJw9WXG3FSGkRgZWa3B6SSvQ29q5JcABLQkA8Wt2cM/gk6
	 S5hCQxiHN6sQvTjKZfYyaKP9OdkZBs3maBKy1fdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/411] selftests: forwarding: lib: Add helpers for checksum handling
Date: Tue, 16 Jun 2026 20:24:38 +0530
Message-ID: <20260616145102.439111033@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 5.15: adjust context]
Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 83e8f9466d6273..c570d8f65a0cec 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1491,3 +1491,59 @@ brmcast_check_sg_state()
 		check_err_fail $should_fail $? "Entry $src has blocked flag"
 	done
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



