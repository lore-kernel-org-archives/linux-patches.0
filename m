Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008514199C;
	Tue, 27 Feb 2024 13:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041543; cv=none; b=dti1HxE8ziaikl8KbgCG4z2v+2XwC0QsYY4wL3SiYJ6EkktMpIAXzMumXh2mZqHK22Wt9UHVWOW6x3OMyHdA/ELyWQs1wBR/WlGn/NZY9FIMli2Tt0H5O0xRe92tnRkOiMSz0eWBvw+azxe8m0BiEId9CaXut5HGX++s5c6AYGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041543; c=relaxed/simple;
	bh=FJzEo7zHULSjtPrdiYHt9WPXg8IsDTtdCArzZZpnycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kygESbkil6e86rXD1FS9n42Zrvr/4wsMKjTVu18BmdSulvTsHiy/g0P0HIsk5M5OjZUNNQ0F6DbDwS59cLYI8b4wLzz24i3DmGorY+CJ575Oq7RuftDWqBUIuaQafAcubZ4qIKayj7jBQkYtXAbpO9JkMPxgWh8Y1L0iE8Yk+mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTUi8fy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTUi8fy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEB2C43390;
	Tue, 27 Feb 2024 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041542;
	bh=FJzEo7zHULSjtPrdiYHt9WPXg8IsDTtdCArzZZpnycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTUi8fy3tVU6SaiaTiTst4Y4Xnq+1jyW5yWzJdr36xPIurcWfnw4aukGFOAD760/N
	 bfnKO5sn/6RacuW4jmnD5+gpTJ3ruJ0CGsAfmmLolbCQTjekFUI9D5L8Y0tOqutoa+
	 oGZO0/CtnUZJ6nIvapASEhIdZ4LZUaJoEnpAEES8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andriin@fb.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/52] scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions
Date: Tue, 27 Feb 2024 14:26:28 +0100
Message-ID: <20240227131549.879401137@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 7a387bed47f7e80e257d966cd64a3e92a63e26a1 ]

Enhance scripts/bpf_helpers_doc.py to emit C header with BPF helper
definitions (to be included from libbpf's bpf_helpers.h).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e37243b65d52 ("bpf, scripts: Correct GPL license name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/bpf_helpers_doc.py | 155 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 1 deletion(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 5010a4d5bfbab..dcddacc25dff3 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -391,6 +391,154 @@ SEE ALSO
 
         print('')
 
+class PrinterHelpers(Printer):
+    """
+    A printer for dumping collected information about helpers as C header to
+    be included from BPF program.
+    @helpers: array of Helper objects to print to standard output
+    """
+
+    type_fwds = [
+            'struct bpf_fib_lookup',
+            'struct bpf_perf_event_data',
+            'struct bpf_perf_event_value',
+            'struct bpf_sock',
+            'struct bpf_sock_addr',
+            'struct bpf_sock_ops',
+            'struct bpf_sock_tuple',
+            'struct bpf_spin_lock',
+            'struct bpf_sysctl',
+            'struct bpf_tcp_sock',
+            'struct bpf_tunnel_key',
+            'struct bpf_xfrm_state',
+            'struct pt_regs',
+            'struct sk_reuseport_md',
+            'struct sockaddr',
+            'struct tcphdr',
+
+            'struct __sk_buff',
+            'struct sk_msg_md',
+            'struct xpd_md',
+    ]
+    known_types = {
+            '...',
+            'void',
+            'const void',
+            'char',
+            'const char',
+            'int',
+            'long',
+            'unsigned long',
+
+            '__be16',
+            '__be32',
+            '__wsum',
+
+            'struct bpf_fib_lookup',
+            'struct bpf_perf_event_data',
+            'struct bpf_perf_event_value',
+            'struct bpf_sock',
+            'struct bpf_sock_addr',
+            'struct bpf_sock_ops',
+            'struct bpf_sock_tuple',
+            'struct bpf_spin_lock',
+            'struct bpf_sysctl',
+            'struct bpf_tcp_sock',
+            'struct bpf_tunnel_key',
+            'struct bpf_xfrm_state',
+            'struct pt_regs',
+            'struct sk_reuseport_md',
+            'struct sockaddr',
+            'struct tcphdr',
+    }
+    mapped_types = {
+            'u8': '__u8',
+            'u16': '__u16',
+            'u32': '__u32',
+            'u64': '__u64',
+            's8': '__s8',
+            's16': '__s16',
+            's32': '__s32',
+            's64': '__s64',
+            'size_t': 'unsigned long',
+            'struct bpf_map': 'void',
+            'struct sk_buff': 'struct __sk_buff',
+            'const struct sk_buff': 'const struct __sk_buff',
+            'struct sk_msg_buff': 'struct sk_msg_md',
+            'struct xdp_buff': 'struct xdp_md',
+    }
+
+    def print_header(self):
+        header = '''\
+/* This is auto-generated file. See bpf_helpers_doc.py for details. */
+
+/* Forward declarations of BPF structs */'''
+
+        print(header)
+        for fwd in self.type_fwds:
+            print('%s;' % fwd)
+        print('')
+
+    def print_footer(self):
+        footer = ''
+        print(footer)
+
+    def map_type(self, t):
+        if t in self.known_types:
+            return t
+        if t in self.mapped_types:
+            return self.mapped_types[t]
+        print("")
+        print("Unrecognized type '%s', please add it to known types!" % t)
+        sys.exit(1)
+
+    seen_helpers = set()
+
+    def print_one(self, helper):
+        proto = helper.proto_break_down()
+
+        if proto['name'] in self.seen_helpers:
+            return
+        self.seen_helpers.add(proto['name'])
+
+        print('/*')
+        print(" * %s" % proto['name'])
+        print(" *")
+        if (helper.desc):
+            # Do not strip all newline characters: formatted code at the end of
+            # a section must be followed by a blank line.
+            for line in re.sub('\n$', '', helper.desc, count=1).split('\n'):
+                print(' *{}{}'.format(' \t' if line else '', line))
+
+        if (helper.ret):
+            print(' *')
+            print(' * Returns')
+            for line in helper.ret.rstrip().split('\n'):
+                print(' *{}{}'.format(' \t' if line else '', line))
+
+        print(' */')
+        print('static %s %s(*%s)(' % (self.map_type(proto['ret_type']),
+                                      proto['ret_star'], proto['name']), end='')
+        comma = ''
+        for i, a in enumerate(proto['args']):
+            t = a['type']
+            n = a['name']
+            if proto['name'] == 'bpf_get_socket_cookie' and i == 0:
+                    t = 'void'
+                    n = 'ctx'
+            one_arg = '{}{}'.format(comma, self.map_type(t))
+            if n:
+                if a['star']:
+                    one_arg += ' {}'.format(a['star'])
+                else:
+                    one_arg += ' '
+                one_arg += '{}'.format(n)
+            comma = ', '
+            print(one_arg, end='')
+
+        print(') = (void *) %d;' % len(self.seen_helpers))
+        print('')
+
 ###############################################################################
 
 # If script is launched from scripts/ from kernel tree and can access
@@ -405,6 +553,8 @@ Parse eBPF header file and generate documentation for eBPF helper functions.
 The RST-formatted output produced can be turned into a manual page with the
 rst2man utility.
 """)
+argParser.add_argument('--header', action='store_true',
+                       help='generate C header file')
 if (os.path.isfile(bpfh)):
     argParser.add_argument('--filename', help='path to include/uapi/linux/bpf.h',
                            default=bpfh)
@@ -417,5 +567,8 @@ headerParser = HeaderParser(args.filename)
 headerParser.run()
 
 # Print formatted output to standard output.
-printer = PrinterRST(headerParser.helpers)
+if args.header:
+    printer = PrinterHelpers(headerParser.helpers)
+else:
+    printer = PrinterRST(headerParser.helpers)
 printer.print_all()
-- 
2.43.0



