Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CEE14EC58;
	Tue, 23 Jul 2024 18:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760000; cv=none; b=Ga2RBacVd0BICE6UYImUYNb1P0LoC1MH8atgggY1r9ltwD4Uybh2JNye/AOEXJqmJD5WvCXNesrxbKOQ6uqxbCxC988MWJIjy5rDIxMFdr17IT8gDc4Noyjc2KQaYJQFjPSPRzTWxgXGIj34AZ0ez8/gOUJpzogiDi9/qCkCqqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760000; c=relaxed/simple;
	bh=Y4UZaBo57hIi7Ft6gADCa8DZYYX+MShFUEIpzqpNVus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA5UGvFOqIg9Y2oraBkBPv/za1Rn9Hi4Po1oa0wAFaQNHOnzaekUuLJqQJzgsw38L7xPVyXOrHztnuXluzURfuiWwGWbpeglAPvY+YP2+aND+3jf0K60IRt2Y5+kmXBf0uZZsrMmvREyuoE9plaueDYgvqww17lNroXgkvHqXsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1LyeOvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1LyeOvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B075C4AF09;
	Tue, 23 Jul 2024 18:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760000;
	bh=Y4UZaBo57hIi7Ft6gADCa8DZYYX+MShFUEIpzqpNVus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1LyeOvSFLXIoV4yNTjvmMvhqfU8xL7jqtNwZqLKcIsY09W/Fg+vBTccWQQhlP6Wk
	 /ZkIBtKOK5+uMIAeMJyUqty9NEHQ/cIEGaYZcqKcNhajLF8GBlDHUjmswDYFbRRqkt
	 sPPmIzyvLO05dHzoTM4uS8A0E/XEqlJLaxKaiKU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 038/163] drm/amdgpu/pptable: Fix UBSAN array-index-out-of-bounds
Date: Tue, 23 Jul 2024 20:22:47 +0200
Message-ID: <20240723180144.946063723@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit c6c4dd54012551cce5cde408b35468f2c62b0cce ]

Flexible arrays used [1] instead of []. Replace the former with the latter
to resolve multiple UBSAN warnings observed on boot with a BONAIRE card.

In addition, use the __counted_by attribute where possible to hint the
length of the arrays to the compiler and any sanitizers.

Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/pptable.h | 91 ++++++++++++++-------------
 1 file changed, 49 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/amd/include/pptable.h b/drivers/gpu/drm/amd/include/pptable.h
index 2e8e6c9875f6c..f83ace2d7ec30 100644
--- a/drivers/gpu/drm/amd/include/pptable.h
+++ b/drivers/gpu/drm/amd/include/pptable.h
@@ -477,31 +477,30 @@ typedef struct _ATOM_PPLIB_STATE_V2
 } ATOM_PPLIB_STATE_V2;
 
 typedef struct _StateArray{
-    //how many states we have 
-    UCHAR ucNumEntries;
-    
-    ATOM_PPLIB_STATE_V2 states[1];
+	//how many states we have
+	UCHAR ucNumEntries;
+
+	ATOM_PPLIB_STATE_V2 states[] /* __counted_by(ucNumEntries) */;
 }StateArray;
 
 
 typedef struct _ClockInfoArray{
-    //how many clock levels we have
-    UCHAR ucNumEntries;
-    
-    //sizeof(ATOM_PPLIB_CLOCK_INFO)
-    UCHAR ucEntrySize;
-    
-    UCHAR clockInfo[];
+	//how many clock levels we have
+	UCHAR ucNumEntries;
+
+	//sizeof(ATOM_PPLIB_CLOCK_INFO)
+	UCHAR ucEntrySize;
+
+	UCHAR clockInfo[];
 }ClockInfoArray;
 
 typedef struct _NonClockInfoArray{
+	//how many non-clock levels we have. normally should be same as number of states
+	UCHAR ucNumEntries;
+	//sizeof(ATOM_PPLIB_NONCLOCK_INFO)
+	UCHAR ucEntrySize;
 
-    //how many non-clock levels we have. normally should be same as number of states
-    UCHAR ucNumEntries;
-    //sizeof(ATOM_PPLIB_NONCLOCK_INFO)
-    UCHAR ucEntrySize;
-    
-    ATOM_PPLIB_NONCLOCK_INFO nonClockInfo[];
+	ATOM_PPLIB_NONCLOCK_INFO nonClockInfo[] __counted_by(ucNumEntries);
 }NonClockInfoArray;
 
 typedef struct _ATOM_PPLIB_Clock_Voltage_Dependency_Record
@@ -513,8 +512,10 @@ typedef struct _ATOM_PPLIB_Clock_Voltage_Dependency_Record
 
 typedef struct _ATOM_PPLIB_Clock_Voltage_Dependency_Table
 {
-    UCHAR ucNumEntries;                                                // Number of entries.
-    ATOM_PPLIB_Clock_Voltage_Dependency_Record entries[1];             // Dynamically allocate entries.
+	// Number of entries.
+	UCHAR ucNumEntries;
+	// Dynamically allocate entries.
+	ATOM_PPLIB_Clock_Voltage_Dependency_Record entries[] __counted_by(ucNumEntries);
 }ATOM_PPLIB_Clock_Voltage_Dependency_Table;
 
 typedef struct _ATOM_PPLIB_Clock_Voltage_Limit_Record
@@ -529,8 +530,10 @@ typedef struct _ATOM_PPLIB_Clock_Voltage_Limit_Record
 
 typedef struct _ATOM_PPLIB_Clock_Voltage_Limit_Table
 {
-    UCHAR ucNumEntries;                                                // Number of entries.
-    ATOM_PPLIB_Clock_Voltage_Limit_Record entries[1];                  // Dynamically allocate entries.
+	// Number of entries.
+	UCHAR ucNumEntries;
+	// Dynamically allocate entries.
+	ATOM_PPLIB_Clock_Voltage_Limit_Record entries[] __counted_by(ucNumEntries);
 }ATOM_PPLIB_Clock_Voltage_Limit_Table;
 
 union _ATOM_PPLIB_CAC_Leakage_Record
@@ -553,8 +556,10 @@ typedef union _ATOM_PPLIB_CAC_Leakage_Record ATOM_PPLIB_CAC_Leakage_Record;
 
 typedef struct _ATOM_PPLIB_CAC_Leakage_Table
 {
-    UCHAR ucNumEntries;                                                 // Number of entries.
-    ATOM_PPLIB_CAC_Leakage_Record entries[1];                           // Dynamically allocate entries.
+	// Number of entries.
+	UCHAR ucNumEntries;
+	// Dynamically allocate entries.
+	ATOM_PPLIB_CAC_Leakage_Record entries[] __counted_by(ucNumEntries);
 }ATOM_PPLIB_CAC_Leakage_Table;
 
 typedef struct _ATOM_PPLIB_PhaseSheddingLimits_Record
@@ -568,8 +573,10 @@ typedef struct _ATOM_PPLIB_PhaseSheddingLimits_Record
 
 typedef struct _ATOM_PPLIB_PhaseSheddingLimits_Table
 {
-    UCHAR ucNumEntries;                                                 // Number of entries.
-    ATOM_PPLIB_PhaseSheddingLimits_Record entries[1];                   // Dynamically allocate entries.
+	// Number of entries.
+	UCHAR ucNumEntries;
+	// Dynamically allocate entries.
+	ATOM_PPLIB_PhaseSheddingLimits_Record entries[] __counted_by(ucNumEntries);
 }ATOM_PPLIB_PhaseSheddingLimits_Table;
 
 typedef struct _VCEClockInfo{
@@ -580,8 +587,8 @@ typedef struct _VCEClockInfo{
 }VCEClockInfo;
 
 typedef struct _VCEClockInfoArray{
-    UCHAR ucNumEntries;
-    VCEClockInfo entries[1];
+	UCHAR ucNumEntries;
+	VCEClockInfo entries[] __counted_by(ucNumEntries);
 }VCEClockInfoArray;
 
 typedef struct _ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record
@@ -592,8 +599,8 @@ typedef struct _ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record
 
 typedef struct _ATOM_PPLIB_VCE_Clock_Voltage_Limit_Table
 {
-    UCHAR numEntries;
-    ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record entries[1];
+	UCHAR numEntries;
+	ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record entries[] __counted_by(numEntries);
 }ATOM_PPLIB_VCE_Clock_Voltage_Limit_Table;
 
 typedef struct _ATOM_PPLIB_VCE_State_Record
@@ -604,8 +611,8 @@ typedef struct _ATOM_PPLIB_VCE_State_Record
 
 typedef struct _ATOM_PPLIB_VCE_State_Table
 {
-    UCHAR numEntries;
-    ATOM_PPLIB_VCE_State_Record entries[1];
+	UCHAR numEntries;
+	ATOM_PPLIB_VCE_State_Record entries[] __counted_by(numEntries);
 }ATOM_PPLIB_VCE_State_Table;
 
 
@@ -626,8 +633,8 @@ typedef struct _UVDClockInfo{
 }UVDClockInfo;
 
 typedef struct _UVDClockInfoArray{
-    UCHAR ucNumEntries;
-    UVDClockInfo entries[1];
+	UCHAR ucNumEntries;
+	UVDClockInfo entries[] __counted_by(ucNumEntries);
 }UVDClockInfoArray;
 
 typedef struct _ATOM_PPLIB_UVD_Clock_Voltage_Limit_Record
@@ -638,8 +645,8 @@ typedef struct _ATOM_PPLIB_UVD_Clock_Voltage_Limit_Record
 
 typedef struct _ATOM_PPLIB_UVD_Clock_Voltage_Limit_Table
 {
-    UCHAR numEntries;
-    ATOM_PPLIB_UVD_Clock_Voltage_Limit_Record entries[1];
+	UCHAR numEntries;
+	ATOM_PPLIB_UVD_Clock_Voltage_Limit_Record entries[] __counted_by(numEntries);
 }ATOM_PPLIB_UVD_Clock_Voltage_Limit_Table;
 
 typedef struct _ATOM_PPLIB_UVD_Table
@@ -657,8 +664,8 @@ typedef struct _ATOM_PPLIB_SAMClk_Voltage_Limit_Record
 }ATOM_PPLIB_SAMClk_Voltage_Limit_Record;
 
 typedef struct _ATOM_PPLIB_SAMClk_Voltage_Limit_Table{
-    UCHAR numEntries;
-    ATOM_PPLIB_SAMClk_Voltage_Limit_Record entries[];
+	UCHAR numEntries;
+	ATOM_PPLIB_SAMClk_Voltage_Limit_Record entries[] __counted_by(numEntries);
 }ATOM_PPLIB_SAMClk_Voltage_Limit_Table;
 
 typedef struct _ATOM_PPLIB_SAMU_Table
@@ -675,8 +682,8 @@ typedef struct _ATOM_PPLIB_ACPClk_Voltage_Limit_Record
 }ATOM_PPLIB_ACPClk_Voltage_Limit_Record;
 
 typedef struct _ATOM_PPLIB_ACPClk_Voltage_Limit_Table{
-    UCHAR numEntries;
-    ATOM_PPLIB_ACPClk_Voltage_Limit_Record entries[1];
+	UCHAR numEntries;
+	ATOM_PPLIB_ACPClk_Voltage_Limit_Record entries[] __counted_by(numEntries);
 }ATOM_PPLIB_ACPClk_Voltage_Limit_Table;
 
 typedef struct _ATOM_PPLIB_ACP_Table
@@ -743,9 +750,9 @@ typedef struct ATOM_PPLIB_VQ_Budgeting_Record{
 } ATOM_PPLIB_VQ_Budgeting_Record;
 
 typedef struct ATOM_PPLIB_VQ_Budgeting_Table {
-    UCHAR revid;
-    UCHAR numEntries;
-    ATOM_PPLIB_VQ_Budgeting_Record         entries[1];
+	UCHAR revid;
+	UCHAR numEntries;
+	ATOM_PPLIB_VQ_Budgeting_Record entries[] __counted_by(numEntries);
 } ATOM_PPLIB_VQ_Budgeting_Table;
 
 #pragma pack()
-- 
2.43.0



