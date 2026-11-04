Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829012;
	b=UT0hp03Z9DrTZHtoyIshACL405GW6wAXF/gjc9cdE5upUUuPPSa6aKmEHgYmSo0FvXYo
	 0JklRU+cNb4W0aUcMZDSc7hTPSPDcM4EpceSfPfsWIHprnO5p0+b4xtNIZJ4Lboj3+y7r
	 qlKtkK0UJmWb0E2DcwwbrbTuwq/IwWUL8AHasakK4P/jV8uoRmEtsqirW8kYGmABNKQH4
	 CUUUk1O9OINsZayKuUSFs9SyH8igBK4ox2X0kFxYnzZl5bMjQ6Xq8Lmr3xSL33HmYPd6/
	 LEgdPwpAYEJKon3MPYJUyc3db5BbRDaHMmP+EcI2qOHy/xZ9S+jxbR2kZe7cWB5hJuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOq5vAbaFy/fDPiXs3Um9o94weF7YxTEy/rCpcGs8qc=;
	b=xYll2HsqHkSokBFfbv1OwE5fyz1fKeYJCZKV/XGB6otymhoVetB1wx44vmasACfWlCOx
	 3kKJHpFwnJSA+9tYXrnVyGAkVrQaRrqnXnTorzZHRbtW//1GNs2Ue+fW+qlBG/lGhsvp4
	 9yvlnDV51cfuD/TYihIRm6NByZiPg7WWgKk4LjNLsrt35lFEG83MQqmKuRdMuNqQ7mt1i
	 iI9Q7V59LTPEH3qbyJVyEK27UOgNH73VJYqbM5YgMYh73vVpj0wBgR6CizEDyrzGZFgoK
	 4vzsz4O/VzRs6vwP5ehV/VlOh+DcvDP2yd7nB+vPziQ2sSOPI4wQDw08IhND2Z7UeNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3nSnfCs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293E76070332;
	Wed,  4 Nov 2026 21:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3nSnfCs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6321F000C1;
	Wed,  4 Nov 2026 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829012;
	bh=VOq5vAbaFy/fDPiXs3Um9o94weF7YxTEy/rCpcGs8qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3nSnfCsuvx44yJRn1Kos/6lsgI0nY2m5Qi7xDhcAjHOagpwPnDJsAnaIg0FB5ZdM
	 QcG4q+i7vfeJKWImGAoV+gJ4NLlGt7PW0vOob5zojFDWfgFU67muOP1qnMaf/K51lN
	 CMgnhLGl8CWizuouGfJtciUhekzPR+FxYSpfuctA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Oliva <diego@bynar.io>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 386/547] smb: client: reject short or out-of-range FIND response parameters
Date: Wed,  4 Nov 2026 16:09:30 -0500
Message-ID: <20261104211049.264474337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Oliva <diego@bynar.io>

commit 531aa4239b0d80d7146b102b98f7aa7da989ccdd upstream.

CIFSFindFirst() and CIFSFindNext() read the SearchHandle, SearchCount,
EndofSearch and LastNameOffset of a TRANS2_FIND_FIRST2 or
TRANS2_FIND_NEXT2 response at ParameterOffset. validate_t2() bounds
the offset at 1024 and ParameterCount below 512, and nothing compares
them with the number of bytes SendReceive() copied into the buffer or
with the size of the response parameters. smb_init() places the
request and the response in the same cifs_request allocation and
cifs_buf_get() clears only the start of it, so a short response with a
ParameterOffset past its end has the search handle, the entry count,
the end-of-search flag and the last-entry offset read out of the
request that was just sent, or out of whatever the allocation held
before, and a ParameterCount smaller than the parameters has them read
past the end of the parameter block. The reads stay inside the
allocation, but what they return is not part of the response, and
CIFSFindFirst() then hands back a search handle the server never sent.
That handle is sent back to the server in the next FIND_NEXT2 or
FIND_CLOSE2, so two bytes of the buffer leak at an offset the server
picks.

SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Reject a response whose parameter area is smaller than the response
parameters or extends past the received length, returning smb_EIO2()
with a new smb_eio_traces value for each of the two responses, like
the other response checks this file gained since v6.19. Backports to
trees before v6.19 need smb_EIO2() replaced with -EINVAL and the
trace.h hunk dropped.

A conforming server is not affected. The parameter block of a
transaction response is part of the SMB, so ParameterOffset +
ParameterCount cannot exceed the smbCalcSize() bytes that
SendReceive() copies, and the response parameters are 10 bytes for
FIND_FIRST2 and 8 bytes for FIND_NEXT2, which is what
T2_FFIRST_RSP_PARMS and T2_FNEXT_RSP_PARMS hold.

This patch depends on "smb: client: reject FIND data areas that run
past the received response", whose declarations it extends.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |   34 ++++++++++++++++++++++++++++------
 fs/smb/client/trace.h   |    2 ++
 2 files changed, 30 insertions(+), 6 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4416,9 +4416,9 @@ CIFSFindFirst(const unsigned int xid, st
 	      struct cifs_search_info *psrch_inf, bool msearch)
 {
 /* level 257 SMB_ */
+	unsigned int parm_off, parm_count, data_off, data_count;
 	TRANSACTION2_FFIRST_REQ *pSMB = NULL;
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
-	unsigned int data_off, data_count;
 	struct nls_table *nls_codepage;
 	T2_FFIRST_RSP_PARMS *parms;
 	unsigned int in_len, lnoff;
@@ -4539,6 +4539,18 @@ findFirstRetry:
 		return rc;
 	}
 
+	parm_off = le16_to_cpu(pSMBr->t2.ParameterOffset);
+	parm_count = le16_to_cpu(pSMBr->t2.ParameterCount);
+	if (parm_count < sizeof(*parms) ||
+	    parm_off + parm_count > (unsigned int)bytes_returned) {
+		cifs_dbg(FYI, "%s: bad parameter area offset %u count %u for response of %d\n",
+			 __func__, parm_off, parm_count, bytes_returned);
+		rc = smb_EIO2(smb_eio_trace_ffirst_param_area,
+			      parm_off, parm_count);
+		cifs_buf_release(pSMB);
+		return rc;
+	}
+
 	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
 	data_count = le16_to_cpu(pSMBr->t2.DataCount);
 	if (data_off + data_count > (unsigned int)bytes_returned) {
@@ -4553,8 +4565,7 @@ findFirstRetry:
 	psrch_inf->smallBuf = false;
 	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol + data_off;
 
-	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
-					le16_to_cpu(pSMBr->t2.ParameterOffset));
+	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol + parm_off);
 	psrch_inf->endOfSearch = !!parms->EndofSearch;
 
 	psrch_inf->entries_in_buffer = le16_to_cpu(parms->SearchCount);
@@ -4582,9 +4593,9 @@ int CIFSFindNext(const unsigned int xid,
 		 __u16 searchHandle, __u16 search_flags,
 		 struct cifs_search_info *psrch_inf)
 {
+	unsigned int parm_off, parm_count, data_off, data_count;
 	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
-	unsigned int data_off, data_count;
 	unsigned int name_len, in_len;
 	T2_FNEXT_RSP_PARMS *parms;
 	unsigned int lnoff;
@@ -4671,6 +4682,18 @@ int CIFSFindNext(const unsigned int xid,
 		return rc;
 	}
 
+	parm_off = le16_to_cpu(pSMBr->t2.ParameterOffset);
+	parm_count = le16_to_cpu(pSMBr->t2.ParameterCount);
+	if (parm_count < sizeof(*parms) ||
+	    parm_off + parm_count > (unsigned int)bytes_returned) {
+		cifs_dbg(FYI, "%s: bad parameter area offset %u count %u for response of %d\n",
+			 __func__, parm_off, parm_count, bytes_returned);
+		rc = smb_EIO2(smb_eio_trace_fnext_param_area,
+			      parm_off, parm_count);
+		cifs_buf_release(pSMB);
+		return rc;
+	}
+
 	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
 	data_count = le16_to_cpu(pSMBr->t2.DataCount);
 	if (data_off + data_count > (unsigned int)bytes_returned) {
@@ -4682,8 +4705,7 @@ int CIFSFindNext(const unsigned int xid,
 
 	/* BB fixme add lock for file (srch_info) struct here */
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
-	response_data = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.ParameterOffset);
+	response_data = (char *)&pSMBr->hdr.Protocol + parm_off;
 	parms = (T2_FNEXT_RSP_PARMS *)response_data;
 	response_data = (char *)&pSMBr->hdr.Protocol + data_off;
 
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -30,6 +30,8 @@
 	EM(smb_eio_trace_ea_next_offset,		"ea_next_offset") \
 	EM(smb_eio_trace_ea_overrun,			"ea_overrun") \
 	EM(smb_eio_trace_extract_will_pin,		"extract_will_pin") \
+	EM(smb_eio_trace_ffirst_param_area,		"ffirst_param_area") \
+	EM(smb_eio_trace_fnext_param_area,		"fnext_param_area") \
 	EM(smb_eio_trace_forced_shutdown,		"forced_shutdown") \
 	EM(smb_eio_trace_getacl_bcc_too_small,		"getacl_bcc_too_small") \
 	EM(smb_eio_trace_getcifsacl_param_count,	"getcifsacl_param_count") \


